import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/projects.dart';
import '../widgets/completed_task_app_bar.dart';
import '../widgets/completed_task_tile.dart';

class CompletedTaskScreen extends StatelessWidget {
  static const routeName = '/completedTaskScreen';
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectDetails = ModalRoute.of(context)!.settings.arguments as Map;
    final projectId = projectDetails['id'];
    final projectTitle = projectDetails['projectTitle'];
    final providerData = Provider.of<Projects>(context);
    // final projects = providerData.projects;
    final completedTasksList = providerData.completedTasksList(
      id: projectId,
    );
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CompletedTaskAppBar(
            size: size,
            completedTasksList: completedTasksList,
            projectTitle: projectTitle,
            providerData: providerData,
            id: projectId,
          ),
          completedTasksList.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    // color: Colors.black,
                    height: size.height * 0.5,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'No completed tasks yet',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : CompletedTaskTile(
                  completedTasksList: completedTasksList,
                  providerData: providerData,
                  projectId: projectId,
                ),
        ],
      ),
    );
  }
}
