import '../api/api_client.dart';
import '../../domain/models/task_model.dart';
import '../../core/constants.dart';

class TaskApi {
  final ApiClient _apiClient;

  TaskApi(this._apiClient);

  Future<List<TaskModel>> getTasks() async {
    final response = await _apiClient.get(AppConstants.todosEndpoint);

    final tasks = (response.data as List)
        .map((task) => TaskModel.fromJson(task))
        .toList();

    return tasks;
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _apiClient.post(
      AppConstants.todosEndpoint,
      data: task.toJson(),
    );

    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient.put(
      '${AppConstants.todosEndpoint}/${task.id}',
      data: task.toJson(),
    );

    return TaskModel.fromJson(response.data);
  }

  Future<void> deleteTask(int taskId) async {
    await _apiClient.delete('${AppConstants.todosEndpoint}/$taskId');
  }

  Future<TaskModel> getTask(int taskId) async {
    final response = await _apiClient.get(
      '${AppConstants.todosEndpoint}/$taskId',
    );
    return TaskModel.fromJson(response.data);
  }
}
