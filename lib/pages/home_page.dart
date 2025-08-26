import 'package:chorebuddies_flutter/tasks/task_view.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/tasks/mock_task_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = mockTasks;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return TaskView(task: items[index]);
          },
        ),
      ),
    );
  }
}
