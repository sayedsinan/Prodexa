import 'package:get/get.dart';
import '../data/api/api_client.dart';
import '../data/api/user_api.dart';
import '../data/repository/user_repository_impl.dart';
import '../domain/repository/i_user_repository.dart';
import '../presentation/users/user_controller.dart';
import '../core/constants.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    // API Client for users
    Get.lazyPut<ApiClient>(
      () => ApiClient(baseUrl: AppConstants.baseAuthUrl),
      tag: 'user',
    );

    // User API
    Get.lazyPut<UserApi>(
      () => UserApi(Get.find<ApiClient>(tag: 'user')),
    );

    // User Repository
    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        Get.find<UserApi>(),
        Get.find<ApiClient>(tag: 'user'),
      ),
    );

    // User Controller
    Get.lazyPut<UserController>(
      () => UserController(Get.find<IUserRepository>()),
    );
  }
}