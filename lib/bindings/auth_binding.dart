import 'package:get/get.dart';
import '../data/api/api_client.dart';
import '../data/api/auth_api.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/i_auth_repository.dart';
import '../presentation/auth/auth_controller.dart';
import '../core/constants.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // API Client
    Get.lazyPut<ApiClient>(
      () => ApiClient(baseUrl: AppConstants.baseAuthUrl),
      tag: 'auth',
    );

    // Auth API
    Get.lazyPut<AuthApi>(
      () => AuthApi(Get.find<ApiClient>(tag: 'auth')),
    );

    // Auth Repository
    Get.lazyPut<IAuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthApi>()),
    );

    // Auth Controller
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<IAuthRepository>()),
    );
  }
}