import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

import 'package:task_list/data/api/api_from_1c.dart';

import 'package:task_list/domain/repository/local_task_repository.dart';
import 'package:task_list/data/auth/firebase_auth.dart';
import 'package:task_list/domain/models/hive_models/task.dart';
import 'package:task_list/main.dart';

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

    on<ClearBoxTapped>((event, emit) {
      state.taskList.clear();
      taskRepository.clearBox();
    });

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
   emit(OperationForTaskState(status: TaskStatus.loading,taskList: state.taskList));    // TODO ADD here taskList if I ruin delete if ruin

    print(
        "OperationForTaskBloc _taskRepository.getListTask().toString(): ${_taskRepository.getListTask()}");
    log(_taskRepository.getListTask().toString(),
        name: 'OperationForTaskBloc _taskRepository.getListTask().toString()');
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

      Task getTask = await ApiFromServer().postTaskForServer(newTask);

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

    for (var task in forRemoveOperation) {
      Task getTask = await ApiFromServer().postTaskForServer(task);

      if (getTask.id != 0) {
        _taskRepository.removeTaskWithTemporaryUUID(task);
        _taskRepository.addTask(getTask);
        allTaskInPageWithoutID
            .removeWhere((task) => task.title == getTask.title);
        allTaskInPageWithID.add(getTask);
      }
    }

    List<Task> updatedTaskList = [];
    updatedTaskList.addAll(allTaskInPageWithID);

    List<Task> getResultsFromServer =
        await ApiFromServer().getTasksFromServer(updatedTaskList);
    for (var task in getResultsFromServer) {
      _taskRepository.addTask(task);
    }

    List<Task> resultTasksForState = [];
    resultTasksForState = _taskRepository.getListTask();
    emit(OperationForTaskState(
        status: TaskStatus.success, taskList: resultTasksForState));
  }

  void taskTapped(TaskTapped event, Emitter<OperationForTaskState> emit) {
    print("Crretn state name:${navigatorKey.currentState.toString()}");
    navigatorKey.currentState?.pushNamed('/task_screen', arguments: event.task);
  }

  Future<void> saveTask() async {}
}
