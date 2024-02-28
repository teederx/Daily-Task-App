import 'package:daily_tasks_app/provider/projects.dart';
import 'package:flutter/material.dart';

class TasksTile extends StatelessWidget {
  const TasksTile({
    super.key,
    required this.height,
    // required this.projectDetails,
    required this.id,
    required this.providerData,
  });

  final double height;
  final String id;
  final Projects providerData;
  // final Map projectDetails;

  @override
  Widget build(BuildContext context) {
    final taskList = providerData.projectTasksList(id: id);
    final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
    return SizedBox(
      height: height * 0.4,
      child: taskList.isEmpty
          ? const Center(
              child: Text(
                'No Tasks yet',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: height * 0.4,
                    child: AnimatedList(
                      key: _animatedListKey,
                      itemBuilder: (context, index, animation) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          resizeDuration: const Duration(milliseconds: 200),
                          key: ObjectKey(
                            taskList.elementAt(index),
                          ),
                          onDismissed: (direction) {
                            providerData.deleteTasks(
                                projectId: id,
                                index: index,
                                taskId: taskList[index].taskId);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task deleted successfully'),
                              ),
                            );
                          },
                          background: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {},
                                leading: InkWell(
                                  onTap: () => providerData.isCompleted(
                                      id: id,
                                      taskId: providerData
                                          .projectTasksList(id: id)[index]
                                          .taskId),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color.fromARGB(
                                        255, 196, 194, 194),
                                    child: taskList[index].isCompleted
                                        ? const Icon(Icons.check_rounded)
                                        : const CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Colors.white,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  taskList[index].title,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  taskList[index].description,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 197, 193, 193),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      initialItemCount: taskList.length,
                    ),
                  ),
                  // SizedBox(
                  //   height: height * 0.4,
                  //   child: ListView.builder(
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         title: Text(
                  //           'item $index',
                  //           style: const TextStyle(color: Colors.black),
                  //         ),
                  //       );
                  //     },
                  //     itemCount: projectDetails['completedTasksLength'],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
