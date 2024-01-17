import 'dart:async';

import 'package:task_list/data/hive_local_storage/task_hive_local_storage.dart';

import '../models/hive_models/task.dart';

class TaskRepository {
  final _taskBox = TaskHiveLocalStorage().box;

  late StreamController<List<Task>> _tasksController;

  Stream<List<Task>> get tasksStream => _tasksController.stream;

  TaskRepository() {
    _tasksController = StreamController<List<Task>>.broadcast();
    _loadTasks();
    // getListTask();
    // _tasksController.add(getListTask());

  }

  List<Task> getListTask() {
    return _taskBox.values.toList();
  }



  void _loadTasks() {
    _taskBox.watch().listen((event) {
      _tasksController.add(_taskBox.values.toList());
    });
  }

  void removeTaskWithTemporaryUUID(Task task) async{

      await TaskHiveLocalStorage().deleteTaskWithTemporaryUUID(task);

  }

  void addTask(Task task) async {
    if (task.id != 0) {
      await TaskHiveLocalStorage().addTask(task);
    } else {
      await TaskHiveLocalStorage().addTaskWithUUID(task);
    }
  }

  void clearBox() {
    TaskHiveLocalStorage().clearBox();
  }

  void dispose() {
    _tasksController.close();
  }
}
