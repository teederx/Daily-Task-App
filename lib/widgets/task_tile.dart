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
    return SizedBox(
      height: height * 0.4,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * 0.4,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
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
                          backgroundColor:
                              const Color.fromARGB(255, 196, 194, 194),
                          child: providerData
                                  .projectTasksList(id: id)[index]
                                  .isCompleted
                              ? const Icon(Icons.check_rounded)
                              : const CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.white,
                                ),
                        ),
                      ),
                      title: Text(
                        providerData.projectTasksList(id: id)[index].title,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        providerData
                            .projectTasksList(id: id)[index]
                            .description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 197, 193, 193),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: providerData.projectTasksList(id: id).length,
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
