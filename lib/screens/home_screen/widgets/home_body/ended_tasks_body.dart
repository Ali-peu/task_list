import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/blocs/operation_for_task/operation_for_task_bloc.dart';
import 'package:task_list/domain/models/hive_models/task.dart';

import '../elements/task_card.dart';

class EndedTaskPage extends StatefulWidget {
  const EndedTaskPage({super.key});

  @override
  State<EndedTaskPage> createState() => _EndedTaskPageState();
}

class _EndedTaskPageState extends State<EndedTaskPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationForTaskBloc, OperationForTaskState>(
      builder: (context, state) {
        List<Task> spesificListTask =
            state.taskList.where((task) => task.status == 'Закрыта').toList();
        print("State _EndedTaskPageState TaskList: ${state.taskList}");
        print("spesificListTask list TaskS == 'Закрыта': $spesificListTask");
        if (spesificListTask.isEmpty) {
          if (state.status == TaskStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status != TaskStatus.success) {
            return const SizedBox();
          } else {
            return const Center(child: Text('JUST TEXT'));
          }
        } else {
          return Stack(children: [
            ListView.builder(
                itemBuilder: (context, index) {
                  return TaskCard(task: spesificListTask[index]);
                },
                itemCount: spesificListTask.length),
            if (state.status == TaskStatus.loading)
              const Opacity(
                opacity: 0.3,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (state.status == TaskStatus.loading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ]);
        }
      },
    );
  }
}
