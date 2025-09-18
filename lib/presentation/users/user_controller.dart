import 'package:get/get.dart';
import '../../data/api/user_api.dart';
import '../../domain/models/user_model.dart';

class UserController extends GetxController {
  final UserApi _userApi = UserApi();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final data = await _userApi.getUsers();
      users.value = data.map<UserModel>((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
