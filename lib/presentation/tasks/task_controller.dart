import 'package:get/get.dart';
import '../../data/api/task_api.dart';
import '../../domain/models/task_model.dart';

class TaskController extends GetxController {
  final TaskApi _taskApi = TaskApi();

  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final data = await _taskApi.getTasks();
      tasks.value = data.map<TaskModel>((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final result = await _taskApi.createTask(task.toJson());
      tasks.add(TaskModel.fromJson(result));
    } catch (e) {
      Get.snackbar("Error", "Failed to create task: $e");
    }
  }
}
