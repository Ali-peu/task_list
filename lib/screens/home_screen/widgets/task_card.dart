import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/blocs/operation_for_task/operation_for_task_bloc.dart';
import 'package:task_list/domain/models/task_model.dart';

class TaskCard extends StatelessWidget {
  // Good
  final Task task;
  const TaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          context
              .read<OperationForTaskBloc>()
              .add(TaskTapped(context: context, task: task));
        },
        child: ListTile(
          title: Text(task.title.toString()),
          subtitle: Text(task.descriptions.toString()),
          trailing: Text(
            'Status:${task.status.toString()}',
            style: const TextStyle(color: Colors.green), // Вынесте в тему
          ),
        ),
      ),
    );
  }
}
