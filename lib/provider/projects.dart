import 'package:daily_tasks_app/data/tasks_data.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:uuid/uuid.dart';

import '../data/project_data.dart';

class Projects extends ChangeNotifier {
  final List<ProjectData> _projects = [
    ProjectData(
      id: const Uuid().v1(),
      projectName: 'Holidays in Canada',
      tasks: [
        TasksData(
          title: 'Create a presentation in key note',
          description: loremIpsum(words: 20),
          timedue: DateTime.now(),
          isCompleted: false,
          taskId: const Uuid().v4(),
        ),
      ],
    ),
    ProjectData(
      id: const Uuid().v1(),
      projectName: 'Daily Tasks',
      tasks: [
        TasksData(
          title: 'Give feedback to team',
          description: loremIpsum(words: 20),
          timedue: DateTime.now(),
          isCompleted: true,
          taskId: const Uuid().v4(),
        ),
        TasksData(
          title: 'Book the return tickets',
          description: loremIpsum(words: 20),
          timedue: DateTime.now(),
          isCompleted: false,
          taskId: const Uuid().v4(),
        ),
      ],
    ),
  ];

  List<ProjectData> get projects {
    return [..._projects];
  }

  List<TasksData> projectTasksList({required String id}) {
    final project = _projects.firstWhere((element) => element.id == id);
    final taskList = project.tasks;
    return taskList;
  }

  List<TasksData> completedTasksList({required String id}) {
    final project = _projects.firstWhere((element) => element.id == id);
    final taskList = project.tasks;
    final completedTaskList =
        taskList.where((element) => element.isCompleted == true).toList();
    return completedTaskList;
  }

  void isCompleted({required String id, required String taskId}) {
    final project = _projects.firstWhere((element) => element.id == id);
    final taskList = project.tasks;
    final task = taskList.firstWhere((element) => element.taskId == taskId);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void isSelected({required String id}) {
    final project = _projects.firstWhere((element) => element.id == id);
    project.isSelected = !project.isSelected;
    notifyListeners();
  }

  void updateProject({
    required String id,
    required TasksData newTask,
  }) {
    final project = _projects.firstWhere((element) => element.id == id);
    final taskList = project.tasks;
    taskList.add(newTask);
    notifyListeners();
  }

  void addNewProject({
    required String id,
    required String projectName,
    required TasksData newTask,
  }) {
    _projects.add(
      ProjectData(
        id: id,
        projectName: projectName,
        tasks: [
          newTask,
        ],
      ),
    );
    notifyListeners();
  }

  void deleteTasks({
    required String projectId,
    required int index,
  }) {
    final project = _projects.firstWhere((element) => element.id == projectId);
    final taskList = project.tasks;
    taskList.removeAt(index);
    notifyListeners();
  }

  void deleteProject ({
    required int index,
  }){
    _projects.removeAt(index);
    notifyListeners();
  }

  void clearAllCompletedTasks({required String projectId}){
    final project = _projects.firstWhere((element) => element.id == projectId);
    final taskList = project.tasks;
    taskList.removeWhere((element) => element.isCompleted == true);
    notifyListeners();
  }
}
