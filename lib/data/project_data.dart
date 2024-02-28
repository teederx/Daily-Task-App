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

  factory ProjectData.fromMap(Map<String, dynamic> json) {
    // Handle potential null values
    final projectId = json['project_id'] as String?;
    final projectName = json['project_title'] as String?;

    if (projectId == null || projectName == null) {
      throw ArgumentError(
          'Missing required fields in JSON: project_id and project_title');
    }
    return ProjectData(
      id: projectId,
      projectName: projectName,
      tasks: [
        TasksData(
          title: json['task_title'],
          description: json['task_description'],
          timedue: DateTime.parse(json['task_timeDue']),
          isCompleted: json['task_completed'] == 1,
          taskId: json['task_id'],
        ),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic>? result = {};
    for (var e in tasks) {
      result.addAll(
        {
          'project_id': id,
          'project_title': projectName,
          'projects.taskIDs': e.taskId,
          'task_id': e.taskId,
          'task_title': e.title,
          'task_description': e.description,
          'task_timeDue': e.timedue.toString(),
          'task_completed': e.isCompleted ? 1 : 0,
        },
      );
    }
    return result;
  }
}
