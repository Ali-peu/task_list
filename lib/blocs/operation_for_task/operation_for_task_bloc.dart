import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

import 'package:task_list/data/api/api_from_1c.dart';
import 'package:task_list/data/auth/firebase_tasks.dart';

import 'package:task_list/domain/repository/local_task_repository.dart';
import 'package:task_list/data/auth/firebase_auth.dart';
import 'package:task_list/domain/models/hive_models/task.dart';

part 'operation_for_task_event.dart';
part 'operation_for_task_state.dart';

class OperationForTaskBloc
    extends Bloc<OperationForTaskEvent, OperationForTaskState> {


  final TaskRepository _taskRepository;

  OperationForTaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const OperationForTaskState()) {
    on<TaskListSubscriptionRequested>(
        (event, emit) => _onSubscriptionRequested(event, emit));

    on<OperationForTaskPressedOK>(
        (event, emit) async => _addingTaskForServer(event, emit));

    on<TaskTapped>((event, emit) => taskTapped(event, emit));

    on<ClearBoxTapped>((event, emit) => TaskRepository().clearBox());

    on<PageViewChange>((event, emit) {
      event.pageController.jumpToPage(event.pageInt);
    });

    on<PageRefreshed>((event, emit) async {
      // TODO
      await pageRefreshed(event, emit);
    });

    on<SignOut>((event, emit) => FirebaseUserAuth().logOut());
  }

  

  Future<void> _onSubscriptionRequested(
    TaskListSubscriptionRequested event,
    Emitter<OperationForTaskState> emit,
  ) async {
    emit(state.copyWith(
        status: () => TaskStatus.loading)); // TODO ADD here taskList if I ruin

    if (_taskRepository.getListTask().isEmpty) {
      emit(const OperationForTaskState(
          status: TaskStatus.success, taskList: []));
    } else {
      emit(OperationForTaskState(
          status: TaskStatus.success,
          taskList: _taskRepository.getListTask())); // TODO Delete the line
      // await emit.forEach<List<Task>>(
      //   _taskRepository.getListTask(),
      //   onData: (tasks) =>
      //       state.copyWith(
      //         status: () => TaskStatus.success,
      //         taskList: () => tasks,
      //       ),
      //   onError: (_, __) =>
      //       state.copyWith(
      //         status: () => TaskStatus.failure,
      //       ),
      // );
    }
  }

  Future<void> _addingTaskForServer(OperationForTaskPressedOK event,
      Emitter<OperationForTaskState> emit) async {
    {
      emit(OperationForTaskState(
          status: TaskStatus.loading, taskList: List.of(state.taskList)));

      Task newTask = Task(
          id: 0,
          title: event.title,
          descriptions: event.descriptipions,
          status: 'Открыта',
          hours: 0,
          temporaryUUID: 'null',
          comments: [],
          refKey: event.refKey,
          listOfStages: []);

      // try{
      //   String companyRefKeyID = await FirebaseUserAuth().getCompainRefKey();
      //   Task getTask =
      //   await ApiFromServer().postTaskForServer(newTask, companyRefKeyID);
      //   _taskRepository.addTask(getTask);
      //   _taskRepository.
      // }
      // catch (error){
      //
      // }
      String companyRefKeyID = await FirebaseUserAuth().getCompanyRefKey();
      String companyName = await FirebaseUserAuth().getCompanyName();

      Task getTask =
          await ApiFromServer().postTaskForServer(newTask, companyRefKeyID);
      FirebaseTasks().addTaskWithId(
          getTask, companyName, companyRefKeyID, getTask.id.toString());
      _taskRepository.addTask(getTask);
      state.taskList.add(getTask);


      emit(OperationForTaskState(
          status: TaskStatus.success, taskList: List.of(state.taskList)));
    }
  }

  Future<void> pageRefreshed(
      PageRefreshed event, Emitter<OperationForTaskState> emit) async {
    emit(OperationForTaskState(
        status: TaskStatus.loading, taskList: state.taskList));

    List<Task> allTaskInPageWithoutID =
        state.taskList.where((element) => element.id == 0).toList();
    List<Task> allTaskInPageWithID = [
      ...state.taskList.where((element) => element.id != 0)
    ];
    List<Task> forRemoveOperation = List.from(allTaskInPageWithoutID);
  

    allTaskInPageWithID.removeWhere((task) => task.id == 0);

    String companyRefKeyID = await FirebaseUserAuth().getCompanyRefKey();

    for (var task in forRemoveOperation) {
      Task getTask =
          await ApiFromServer().postTaskForServer(task, companyRefKeyID);

      if (getTask.id != 0) {
        _taskRepository.removeTaskWithTemporaryUUID(task);
        _taskRepository.addTask(getTask);
        allTaskInPageWithoutID
            .removeWhere((task) => task.title == getTask.title);
        allTaskInPageWithID.add(getTask);
      }
    }
    // for(var task in forUpdateOperation){
    //   Task getTask = await ApiFromServer
    //
    // }

    List<Task> updatedTaskList = [];
    updatedTaskList.addAll(allTaskInPageWithID);

    List<Task> getResultsFromServer =
        await ApiFromServer().getTasksFromServer(updatedTaskList);
    for (var task in getResultsFromServer) {
      _taskRepository.addTask(task);
    }

    List<Task> resultTasksForState = [];
    resultTasksForState.addAll(getResultsFromServer);
    resultTasksForState.addAll(allTaskInPageWithoutID);
    emit(OperationForTaskState(
        status: TaskStatus.success, taskList: resultTasksForState));
  }

  void taskTapped(TaskTapped event, Emitter<OperationForTaskState> emit) {
    Navigator.pushNamed(event.context, '/task_screen', arguments: event.task);
  }

  Future<void> saveTask() async {}
}
