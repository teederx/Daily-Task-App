import 'package:daily_tasks_app/data/tasks_data.dart';
import 'package:flutter/material.dart';

import '../provider/projects.dart';

class CompletedTaskAppBar extends StatelessWidget {
  const CompletedTaskAppBar({
    super.key,
    required this.size,
    required this.completedTasksList,
    required this.projectTitle,
    required this.providerData,
    required this.id,
  });

  final Size size;
  final List<TasksData> completedTasksList;
  final String projectTitle;
  final Projects providerData;
  final String id;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 56,
      expandedHeight: size.height * 0.34,
      pinned: true,
      stretch: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      actions: [
        PopupMenuButton(
          position: PopupMenuPosition.under,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete_outline_rounded),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Clear all'),
                ],
              ),
              onTap: () {
                providerData.clearAllCompletedTasks(projectId: id);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All completed tasks cleared successfully'),
                  ),
                );
              },
              // providerData,
            ),
          ],
        ),
      ],
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
          stretchModes: const [
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
            StretchMode.zoomBackground,
          ],
          expandedTitleScale: 2,
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1,
            child: top > 71 && top < 91
                ? Text(
                    "COMPLETED TASKS (${completedTasksList.length})",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      letterSpacing: 0.5,
                      // fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "COMPLETED TASKS (${completedTasksList.length})",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 139, 133, 133),
                      fontSize: 9,
                      letterSpacing: 0.5,
                      // fontWeight: FontWeight.w200,
                    ),
                  ),
          ),
          background: Stack(
            children: [
              Card(
                surfaceTintColor: Colors.black,
                margin: const EdgeInsets.all(0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                // margin: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: size.height * 0.4,
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(45),
                    //   bottomRight: Radius.circular(45),
                    // ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          width: (size.width * 0.5) - 15,
                          child: Text(
                            projectTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 38,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (size.width * 0.5) - 15,
                          child: const Icon(
                            Icons.task_rounded,
                            color: Colors.black,
                            size: 100,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
