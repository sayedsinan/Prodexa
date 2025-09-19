import 'package:get/get.dart';
import '../data/api/api_client.dart';
import '../data/api/task_api.dart';
import '../data/repository/task_repository_impl.dart';
import '../domain/repository/i_task_repository.dart';
import '../presentation/tasks/task_controller.dart';
import '../core/constants.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    // API Client for tasks
    Get.lazyPut<ApiClient>(
      () => ApiClient(baseUrl: AppConstants.baseTaskUrl),
      tag: 'task',
    );

    // Task API
    Get.lazyPut<TaskApi>(
      () => TaskApi(Get.find<ApiClient>(tag: 'task')),
    );

    // Task Repository
    Get.lazyPut<ITaskRepository>(
      () => TaskRepositoryImpl(
        Get.find<TaskApi>(), 
        Get.find<ApiClient>(tag: 'task'),
      ),
    );

    // Task Controller
    Get.lazyPut<TaskController>(
      () => TaskController(Get.find<ITaskRepository>()),
    );
  }
}
