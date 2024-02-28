import 'package:daily_tasks_app/data/tasks_data.dart';
import 'package:flutter/material.dart';

import '../provider/projects.dart';

class CompletedTaskTile extends StatelessWidget {
  const CompletedTaskTile({
    super.key,
    required this.completedTasksList,
    required this.providerData,
    required this.projectId,
  });

  final List<TasksData> completedTasksList;
  final Projects providerData;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Text('$index')
          return Dismissible(
            direction: DismissDirection.endToStart,
            resizeDuration: const Duration(milliseconds: 200),
            key: ObjectKey(
              completedTasksList.elementAt(index),
            ),
            onDismissed: (direction) {
              providerData.deleteTasks(projectId: projectId, index: index, taskId: completedTasksList[index].taskId);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted successfully'),
                ),
              );
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
            ),
            child: Card(
              color: Colors.white,
              child: ListTile(
                onTap: () {},
                title: Text(
                  completedTasksList[index].title,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  completedTasksList[index].description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 197, 193, 193),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: completedTasksList.length,
      ),
    );
  }
}