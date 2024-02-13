import 'package:daily_tasks_app/data/tasks_data.dart';

class ProjectData {
  ProjectData({
    required this.id,
    required this.projectName,
    required this.tasks,
    this.isSelected = false,
  });

  final String id;
  final String projectName;
  final List<TasksData> tasks;
  bool isSelected;
}
