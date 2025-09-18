import 'api_client.dart';
import '../../core/constants.dart';

class TaskApi extends ApiClient {
  Future<List<dynamic>> getTasks() async {
    final response = await dio.get("${AppConstants.baseUrlTodos}/todos");
    return response.data;
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> task) async {
    final response = await dio.post("${AppConstants.baseUrlTodos}/todos", data: task);
    return response.data;
  }

  Future<Map<String, dynamic>> updateTask(int id, Map<String, dynamic> task) async {
    final response = await dio.put("${AppConstants.baseUrlTodos}/todos/$id", data: task);
    return response.data;
  }

  Future<void> deleteTask(int id) async {
    await dio.delete("${AppConstants.baseUrlTodos}/todos/$id");
  }
}
