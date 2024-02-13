import 'package:daily_tasks_app/provider/projects.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/task_tile.dart';
import '../widgets/title_card.dart';

class TasksScreen extends StatelessWidget {
  static const routeName = '/TasksScreen';
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectDetails = ModalRoute.of(context)!.settings.arguments as Map;
    final providerData = Provider.of<Projects>(context);
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TitleCard(
              projectDetails: projectDetails,
              height: height,
              id: projectDetails['id'],
              providerData: providerData,
            ),
            TasksTile(
              height: height,
              providerData: providerData,
              id: projectDetails['id'],
            ),
          ],
        ),
      ),
    );
  }
}
