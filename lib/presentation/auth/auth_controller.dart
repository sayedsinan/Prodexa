import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/i_auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../core/app_routes.dart';
import '../../core/constants.dart';

class AuthController extends GetxController {
  final IAuthRepository _authRepository;

  AuthController(this._authRepository);

  // Observable variables
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.onClose();
  // }

  Future<void> checkAuthStatus() async {
    try {
      _isLoading.value = true;
      
      final loggedIn = await _authRepository.isLoggedIn();
      _isLoggedIn.value = loggedIn;
      
      if (loggedIn) {
        final user = await _authRepository.getCurrentUser();
        _currentUser.value = user;
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!_validateLoginForm()) return;

    try {
      _isLoading.value = true;
      
      final authModel = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      _currentUser.value = authModel.user;
      _isLoggedIn.value = true;
      
      Get.snackbar(
        'Success',
        AppConstants.loginSuccessMessage,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Get.offAllNamed(AppRoutes.taskList);
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    try {
      _isLoading.value = true;
      
      final authModel = await _authRepository.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      _currentUser.value = authModel.user;
      _isLoggedIn.value = true;
      
      Get.snackbar(
        'Success',
        AppConstants.registerSuccessMessage,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Get.offAllNamed(AppRoutes.taskList);
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;
      
      await _authRepository.logout();
      
      _currentUser.value = null;
      _isLoggedIn.value = false;
      
      _clearForm();
      
      Get.offAllNamed(AppRoutes.login);
      
      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  bool _validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Email is required');
      return false;
    }
    
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Validation Error', 'Please enter a valid email');
      return false;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Password is required');
      return false;
    }
    
    if (passwordController.text.length < 6) {
      Get.snackbar('Validation Error', 'Password must be at least 6 characters');
      return false;
    }
    
    return true;
  }

  bool _validateRegisterForm() {
    if (!_validateLoginForm()) return false;
    
    if (confirmPasswordController.text != passwordController.text) {
      Get.snackbar('Validation Error', 'Passwords do not match');
      return false;
    }
    
    return true;
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void fillDemoCredentials() {
    emailController.text = AppConstants.defaultEmail;
    passwordController.text = 'password123';
    confirmPasswordController.text = 'password123';
  }
}
