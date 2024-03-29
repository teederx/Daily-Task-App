import 'package:flutter/material.dart';

import '../provider/projects.dart';
import '../screens/completed_task_screen.dart';
import '../screens/new_task_screen.dart';
import 'bar.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.projectDetails,
    required this.height,
    required this.id,
    required this.providerData,
    required this.index,
  });

  final Map projectDetails;
  final double height;
  final String id;
  final Projects providerData;
  final int index;

  @override
  Widget build(BuildContext context) {
    final totalTasksList = providerData.projectTasksList(id: id);
    final completedTasksList = providerData.completedTasksList(id: id);
    return Stack(
      // alignment: Alignment.center,
      children: [
        SizedBox(
          height: (height * 0.5) + 25,
        ),
        Card(
          surfaceTintColor: Colors.black,
          margin: const EdgeInsets.all(0),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
          // margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: height * 0.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
              // backgroundBlendMode: BlendMode.colorBurn,
              gradient: SweepGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.purple,
                  Colors.pinkAccent,
                  Colors.purple,
                  Colors.blue,
                ],
                startAngle: 4.5,
                center: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color.fromRGBO(233, 233, 233, 1),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          position: PopupMenuPosition.under,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color.fromRGBO(233, 233, 233, 1),
                              child: Icon(
                                Icons.more_horiz,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.task_alt_rounded),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Show Completed Tasks'),
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                CompletedTaskScreen.routeName,
                                arguments: {
                                  'id': id,
                                  'projectTitle': projectDetails['title'],
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectDetails['title'],
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
                                totalPercentage: totalTasksList.isEmpty
                                    ? 0
                                    : completedTasksList.length /
                                        totalTasksList.length,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '${completedTasksList.length}/${totalTasksList.length}',
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
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width * 0.40,
          child: InkWell(
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
                border: Border.all(width: 1.5, color: Colors.white),
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(209, 207, 207, 0.624),
                    Color.fromRGBO(151, 149, 149, 0.925),
                    Color.fromRGBO(92, 91, 91, 0.624),
                    Color.fromRGBO(48, 47, 47, 0.259),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(50),
                ),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white54,
                child: Icon(
                  Icons.add_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
