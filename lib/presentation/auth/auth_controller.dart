import 'package:get/get.dart';
import '../../data/api/auth_api.dart';

class AuthController extends GetxController {
  final AuthApi _authApi = AuthApi();

  var isLoading = false.obs;
  var token = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final result = await _authApi.login(email, password);
      token.value = result['token'] ?? '';
      Get.offAllNamed('/tasks');
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      final result = await _authApi.register(email, password);
      token.value = result['token'] ?? '';
      Get.offAllNamed('/tasks');
    } catch (e) {
      Get.snackbar("Error", "Register failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
