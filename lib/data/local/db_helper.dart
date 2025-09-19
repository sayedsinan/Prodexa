import 'dart:async';
import 'package:logger/logger.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/user_model.dart';
import 'hive_service.dart';

class DbHelper {
  static final Logger _logger = Logger();

  
  static Future<bool> saveTasksWithErrorHandling(List<TaskModel> tasks) async {
    try {
      await HiveService.saveTasks(tasks);
      _logger.i('Saved ${tasks.length} tasks to local storage');
      return true;
    } catch (e) {
      _logger.e('Error saving tasks to local storage: $e');
      return false;
    }
  }

  static Future<bool> saveTaskWithErrorHandling(TaskModel task) async {
    try {
      await HiveService.saveTask(task);
      _logger.i('Saved task ${task.id} to local storage');
      return true;
    } catch (e) {
      _logger.e('Error saving task to local storage: $e');
      return false;
    }
  }

  static Future<bool> deleteTaskWithErrorHandling(int id) async {
    try {
      await HiveService.deleteTask(id);
      _logger.i('Deleted task $id from local storage');
      return true;
    } catch (e) {
      _logger.e('Error deleting task from local storage: $e');
      return false;
    }
  }


  static Future<bool> saveUsersWithErrorHandling(List<UserModel> users) async {
    try {
      await HiveService.saveUsers(users);
      _logger.i('Saved ${users.length} users to local storage');
      return true;
    } catch (e) {
      _logger.e('Error saving users to local storage: $e');
      return false;
    }
  }

  static List<TaskModel> searchTasks(String query) {
    try {
      final tasks = HiveService.getTasks();
      if (query.isEmpty) return tasks;

      return tasks.where((task) {
        final titleMatch = task.title.toLowerCase().contains(query.toLowerCase());
        final descMatch = task.description.toLowerCase().contains(query.toLowerCase());
        return titleMatch || descMatch;
      }).toList();
    } catch (e) {
      _logger.e('Error searching tasks: $e');
      return [];
    }
  }

  static List<TaskModel> filterTasksByStatus(String status) {
    try {
      final tasks = HiveService.getTasks();
      return tasks.where((task) => task.status == status).toList();
    } catch (e) {
      _logger.e('Error filtering tasks by status: $e');
      return [];
    }
  }

  static List<TaskModel> filterTasksByPriority(String priority) {
    try {
      final tasks = HiveService.getTasks();
      return tasks.where((task) => task.priority == priority).toList();
    } catch (e) {
      _logger.e('Error filtering tasks by priority: $e');
      return [];
    }
  }

  static List<TaskModel> getOverdueTasks() {
    try {
      final tasks = HiveService.getTasks();
      return tasks.where((task) => task.isOverdue).toList();
    } catch (e) {
      _logger.e('Error getting overdue tasks: $e');
      return [];
    }
  }

  static List<TaskModel> getTasksDueToday() {
    try {
      final tasks = HiveService.getTasks();
      return tasks.where((task) => task.isDueToday).toList();
    } catch (e) {
      _logger.e('Error getting tasks due today: $e');
      return [];
    }
  }

  static List<TaskModel> getTasksByUser(int userId) {
    try {
      final tasks = HiveService.getTasks();
      return tasks.where((task) => task.assignedUserId == userId).toList();
    } catch (e) {
      _logger.e('Error getting tasks by user: $e');
      return [];
    }
  }

  static Map<String, int> getTaskStatistics() {
    try {
      final tasks = HiveService.getTasks();
      return {
        'total': tasks.length,
        'completed': tasks.where((task) => task.completed).length,
        'pending': tasks.where((task) => !task.completed).length,
        'overdue': tasks.where((task) => task.isOverdue).length,
        'dueToday': tasks.where((task) => task.isDueToday).length,
        'highPriority': tasks.where((task) => task.priority == 'High').length,
        'mediumPriority': tasks.where((task) => task.priority == 'Medium').length,
        'lowPriority': tasks.where((task) => task.priority == 'Low').length,
      };
    } catch (e) {
      _logger.e('Error getting task statistics: $e');
      return {};
    }
  }
}