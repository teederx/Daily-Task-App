
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

  Map<String, dynamic> toMap() {
    return {
      'title': title, // Replace with your property names
      'description': description,
      'timeDue': timedue.toString(), // Convert DateTime to string for storage
      'completed': isCompleted ? 1 : 0, // Convert bool to integer
      'id': taskId, // Add other task-related properties
    };
  }
}
