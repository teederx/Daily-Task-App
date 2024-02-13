import 'package:daily_tasks_app/screens/tasks_screen.dart';
import 'package:daily_tasks_app/widgets/bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/projects.dart';
import '../screens/new_task_screen.dart';

class ProjectWidget extends StatelessWidget {
  const ProjectWidget({
    super.key,
    required this.projectTitle,
    // required this.completedTasksLength,
    required this.id,
  });

  final String id;
  final String projectTitle;
  // final int completedTasksLength;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Projects>(context);
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        TasksScreen.routeName,
        arguments: {
          'id': id,
          'title': projectTitle,
        },
      ),
      child: Card(
        // surfaceTintColor: Colors.black,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        margin: const EdgeInsets.all(15),
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            // backgroundBlendMode: BlendMode.colorBurn,
            gradient: const SweepGradient(
              colors: [
                Colors.blueAccent,
                Colors.purple,
                Colors.pinkAccent,
                Colors.purple,
                Colors.blue,
              ],
              startAngle: 4.5,
              center: Alignment.bottomLeft,
              // focal: Alignment.centerLeft,
              // radius: 2,
              // end: Alignment.center,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 10, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Bar(
                              totalPercentage: providerData
                                      .completedTasksList(id: id)
                                      .length /
                                  providerData.projectTasksList(id: id).length,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${providerData.completedTasksList(id: id).length}/${providerData.projectTasksList(id: id).length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const Text(
                                  'tasks',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white12,
                            child: Icon(
                              Icons.more_horiz_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AnimatedContainer(
                              height: height,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: NewTaskScreen(
                                id: id,
                              ),
                            );
                          },
                          isScrollControlled: true,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white54,
                            child: Icon(
                              Icons.add_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
