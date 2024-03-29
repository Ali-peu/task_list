part of 'operation_for_task_bloc.dart';

sealed class OperationForTaskEvent extends Equatable {
  const OperationForTaskEvent();

  @override
  List<Object> get props => [];
}

class TaskListSubscriptionRequested extends OperationForTaskEvent {
  const TaskListSubscriptionRequested();
}

class OperationForTaskPressedOK extends OperationForTaskEvent {
  final String title;
  final String descriptipions;

  final String refKey;

  const OperationForTaskPressedOK(
      this.title, this.descriptipions, this.refKey);
}

class DeleteTask extends OperationForTaskEvent {
  final int taskId;

  const DeleteTask(this.taskId);
}

class TaskTapped extends OperationForTaskEvent {
  final BuildContext context;
  final Task task;
  const TaskTapped({required this.context, required this.task});
}

class ClearBoxTapped extends OperationForTaskEvent {}

class PageRefreshed extends OperationForTaskEvent {
  final List<Task> listTask;
  const PageRefreshed({required this.listTask});
}

class SignOut extends OperationForTaskEvent {}


class PageViewChange extends OperationForTaskEvent{
  final int pageInt;
  final PageController pageController;
  const PageViewChange({required this.pageInt,required this.pageController});
}