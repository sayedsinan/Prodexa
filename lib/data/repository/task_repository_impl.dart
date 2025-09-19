import 'package:logger/logger.dart';
import '../../domain/repository/i_task_repository.dart';
import '../../domain/models/task_model.dart';
import '../api/api_client.dart';
import '../api/task_api.dart';
import '../local/hive_service.dart';
import '../local/db_helper.dart';
// import '../../core/constants.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final TaskApi _taskApi;
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  TaskRepositoryImpl(this._taskApi, this._apiClient);

  @override
  Future<List<TaskModel>> getTasks({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || !await _apiClient.hasNetworkConnection()) {
        return _getTasksFromLocal();
      }

      try {
  
        final tasks = await _taskApi.getTasks();
        
        final enhancedTasks = tasks.map((task) => task.copyWith(
          description: task.description.isNotEmpty ? task.description : task.title,
          priority: 'Medium',
          status: task.completed ? 'Done' : 'To-Do',
          createdAt: DateTime.now().subtract(Duration(days: task.id % 30)),
          updatedAt: DateTime.now(),
        )).toList();

  
        await DbHelper.saveTasksWithErrorHandling(enhancedTasks);
        
        _logger.i('Fetched ${enhancedTasks.length} tasks from API');
        return enhancedTasks;
      } catch (e) {
        _logger.w('API fetch failed, falling back to local data: $e');
        return _getTasksFromLocal();
      }
    } catch (e) {
      _logger.e('Failed to get tasks: $e');
      return [];
    }
  }

  List<TaskModel> _getTasksFromLocal() {
    final tasks = HiveService.getTasks();
    _logger.i('Retrieved ${tasks.length} tasks from local storage');
    return tasks;
  }

  @override
  Future<TaskModel> getTask(int id, {bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final localTask = HiveService.getTask(id);
        if (localTask != null) {
          _logger.i('Retrieved task $id from local storage');
          return localTask;
        }
      }

      if (await _apiClient.hasNetworkConnection()) {
        try {
          final task = await _taskApi.getTask(id);
          final enhancedTask = task.copyWith(
            description: task.description.isNotEmpty ? task.description : task.title,
            priority: 'Medium',
            status: task.completed ? 'Done' : 'To-Do',
            createdAt: DateTime.now().subtract(Duration(days: id % 30)),
            updatedAt: DateTime.now(),
          );

          await DbHelper.saveTaskWithErrorHandling(enhancedTask);
          return enhancedTask;
        } catch (e) {
          _logger.w('API fetch failed for task $id: $e');
        }
      }
      final localTask = HiveService.getTask(id);
      if (localTask != null) {
        return localTask;
      }

      throw Exception('Task not found');
    } catch (e) {
      _logger.e('Failed to get task $id: $e');
      rethrow;
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      TaskModel createdTask;

      if (await _apiClient.hasNetworkConnection()) {
        try {
          createdTask = await _taskApi.createTask(task);
        
          createdTask = createdTask.copyWith(
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            priority: task.priority,
            status: task.status,
            assignedUserId: task.assignedUserId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        } catch (e) {
          _logger.w('API create failed, creating locally: $e');
 
          final localTasks = HiveService.getTasks();
          final maxId = localTasks.isEmpty ? 0 : localTasks.map((t) => t.id).reduce((a, b) => a > b ? a : b);
          createdTask = task.copyWith(
            id: maxId + 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      } else {

        final localTasks = HiveService.getTasks();
        final maxId = localTasks.isEmpty ? 0 : localTasks.map((t) => t.id).reduce((a, b) => a > b ? a : b);
        createdTask = task.copyWith(
          id: maxId + 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      await DbHelper.saveTaskWithErrorHandling(createdTask);
      _logger.i('Created task: ${createdTask.title}');
      return createdTask;
    } catch (e) {
      _logger.e('Failed to create task: $e');
      rethrow;
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      TaskModel updatedTask = task.copyWith(updatedAt: DateTime.now());

      if (await _apiClient.hasNetworkConnection()) {
        try {
          updatedTask = await _taskApi.updateTask(updatedTask);
          
          updatedTask = updatedTask.copyWith(
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            priority: task.priority,
            status: task.status,
            assignedUserId: task.assignedUserId,
            updatedAt: DateTime.now(),
          );
        } catch (e) {
          _logger.w('API update failed, updating locally: $e');
        }
      }

      await DbHelper.saveTaskWithErrorHandling(updatedTask);
      _logger.i('Updated task: ${updatedTask.title}');
      return updatedTask;
    } catch (e) {
      _logger.e('Failed to update task: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      if (await _apiClient.hasNetworkConnection()) {
        try {
          await _taskApi.deleteTask(id);
        } catch (e) {
          _logger.w('API delete failed, deleting locally: $e');
        }
      }

      await DbHelper.deleteTaskWithErrorHandling(id);
      _logger.i('Deleted task: $id');
    } catch (e) {
      _logger.e('Failed to delete task $id: $e');
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      return DbHelper.searchTasks(query);
    } catch (e) {
      _logger.e('Failed to search tasks: $e');
      return [];
    }
  }

  @override
  Future<List<TaskModel>> filterTasksByStatus(String status) async {
    try {
      return DbHelper.filterTasksByStatus(status);
    } catch (e) {
      _logger.e('Failed to filter tasks by status: $e');
      return [];
    }
  }

  @override
  Future<List<TaskModel>> filterTasksByPriority(String priority) async {
    try {
      return DbHelper.filterTasksByPriority(priority);
    } catch (e) {
      _logger.e('Failed to filter tasks by priority: $e');
      return [];
    }
  }

  @override
  Future<List<TaskModel>> getOverdueTasks() async {
    try {
      return DbHelper.getOverdueTasks();
    } catch (e) {
      _logger.e('Failed to get overdue tasks: $e');
      return [];
    }
  }

  @override
  Future<List<TaskModel>> getTasksDueToday() async {
    try {
      return DbHelper.getTasksDueToday();
    } catch (e) {
      _logger.e('Failed to get tasks due today: $e');
      return [];
    }
  }

  @override
  Future<Map<String, int>> getTaskStatistics() async {
    try {
      return DbHelper.getTaskStatistics();
    } catch (e) {
      _logger.e('Failed to get task statistics: $e');
      return {};
    }
  }
}