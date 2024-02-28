import 'dart:io';

import 'package:daily_tasks_app/data/project_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../data/tasks_data.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String paths = path.join(documentsDirectory.path, 'projects.db');
    return await sql.openDatabase(
      paths,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects(
        id TEXT PRIMARY KEY, 
        title TEXT,
        taskIDs TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY, 
        title TEXT, 
        description TEXT, 
        completed INTEGER, 
        timeDue TEXT
      )
    ''');
  }

  Future<List<ProjectData>> getProjects() async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> projects = await db.rawQuery('''
      SELECT p.id AS project_id, p.title AS project_title,
             t.id AS task_id, t.title AS task_title,
             t.description AS task_description, t.completed AS task_completed,
             t.timeDue AS task_timeDue
      FROM projects AS p
      LEFT JOIN tasks AS t ON p.taskIDs = t.id -- Assuming 'id' column in tasks table
      ''');

    List<ProjectData> projectList = projects.isNotEmpty
        ? projects.map((e) => ProjectData.fromMap(e)).toList()
        : [];
    return projectList;
  }

  Future<void> add(ProjectData projectData) async {
    Database db = await instance.database;

    // Convert task IDs to string for storage
    String taskIds = projectData.tasks.map((t) => t.taskId).join(',');

    // 1. Insert project data into the 'projects' table
    await db.insert('projects', {
      'id': projectData.id,
      'title': projectData.projectName,
      'taskIDs': taskIds
    });

    // 2. Insert each task into the 'tasks' table
    for (TasksData task in projectData.tasks) {
      await db.insert('tasks', task.toMap());
    }

    // return projectId; // Return the newly created project ID
  }

  Future<void> removeProject(String id) async {
    Database db = await instance.database;

    // Start a transaction to ensure consistency
    return await db.transaction((txn) async {
      // 1. Delete project tasks using the transaction object
      await txn.delete(
        'tasks',
        where: 'id IN (SELECT taskId FROM project_tasks WHERE project_id = ?)',
        whereArgs: [id],
      );

      // 2. Delete the project itself
      await txn.delete(
        'projects',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Return the combined number of deleted tasks and the project itself
      // return deletedTasks + deletedProject;
    });
  }

  Future<void> removeTask(String projectId, String taskId) async {
    Database db = await instance.database;

    // 1. Update the project's task list by removing the specified task ID
    int updatedRows = await db.rawUpdate('''
    UPDATE projects
    SET taskIDs = REPLACE(taskIDs, ?, ?)
    WHERE id = ?
  ''', [', $taskId,', '', projectId]);

    // 2. Delete the removed task from the 'tasks' table if not referenced by other projects
    if (updatedRows > 0) {
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [taskId],
      );
    }

    // return updatedRows; // Return the number of rows updated in the 'projects' table
  }

  Future<void> updateProject(ProjectData projectData) async {
    Database db = await instance.database;

    // Start a transaction to ensure consistency
    await db.transaction((txn) async {
      // 1. Update project data in the 'projects' table
      await txn.update(
          'projects',
          {
            'id': projectData.id,
            'title': projectData.projectName,
          },
          where: 'id = ?',
          whereArgs: [projectData.id]);

      // 2. Insert any new tasks into the 'tasks' table
      for (TasksData task in projectData.tasks) {
        // Check if the task ID already exists
        int existingTaskIdCount = await txn.query(
          'tasks',
          where: 'id = ?',
          whereArgs: [task.taskId],
        ).then((rows) => rows.length);

        if (existingTaskIdCount == 0) {
          // If new task, insert it
          await txn.insert('tasks', task.toMap());
        } else {
          // If existing task, update its data if necessary (optional)
          // You can implement optional logic to update existing task data here
          // For example:
          // await txn.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.taskId]);
        }
      }
    });
  }
}
