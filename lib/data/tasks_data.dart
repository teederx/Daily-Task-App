
class TasksData {
  TasksData({
    required this.title,
    required this.description,
    required this.timedue,
    required this.isCompleted,
    required this.taskId,
  });

  String taskId;
  final String title;
  final String description;
  final DateTime timedue;
  bool isCompleted;
}
