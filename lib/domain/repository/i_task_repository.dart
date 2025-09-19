import '../models/task_model.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getTasks({bool forceRefresh = false});
  
  Future<TaskModel> getTask(int id, {bool forceRefresh = false});
  
  Future<TaskModel> createTask(TaskModel task);
  
  Future<TaskModel> updateTask(TaskModel task);
  
  Future<void> deleteTask(int id);
  
  Future<List<TaskModel>> searchTasks(String query);
  
  Future<List<TaskModel>> filterTasksByStatus(String status);
  
  Future<List<TaskModel>> filterTasksByPriority(String priority);
  
  Future<List<TaskModel>> getOverdueTasks();
  
  Future<List<TaskModel>> getTasksDueToday();
  
  Future<Map<String, int>> getTaskStatistics();
}
