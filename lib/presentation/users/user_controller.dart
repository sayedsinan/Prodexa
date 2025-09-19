import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/i_user_repository.dart';
import '../../domain/models/user_model.dart';

class UserController extends GetxController {
  final IUserRepository _userRepository;

  UserController(this._userRepository);

  // Observable variables
  final _isLoading = false.obs;
  final _users = <UserModel>[].obs;
  final _selectedUser = Rxn<UserModel>();

  // Getters
  bool get isLoading => _isLoading.value;
  List<UserModel> get users => _users;
  UserModel? get selectedUser => _selectedUser.value;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers({bool forceRefresh = false}) async {
    try {
      _isLoading.value = true;
      
      final userList = await _userRepository.getUsers(forceRefresh: forceRefresh);
      _users.value = userList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load users: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<UserModel?> getUser(int id) async {
    try {
      return await _userRepository.getUser(id);
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  void selectUser(UserModel user) {
    _selectedUser.value = user;
  }

  UserModel? getUserById(int? id) {
    if (id == null) return null;
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}
