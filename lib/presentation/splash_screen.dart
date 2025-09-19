import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_management_app/presentation/auth/auth_controller.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    final authController = Get.find<AuthController>();
    await authController.checkAuthStatus();
    if (authController.isLoggedIn) {
      Get.offAllNamed(AppRoutes.taskList);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.task_alt,
              size: 100,
              color: Colors.white,
            ).animate().scale(duration: 600.ms).fadeIn(),
            const SizedBox(height: 24),
            const Text(
              'Task Manager',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().slideY(begin: 1, duration: 600.ms).fadeIn(),
            const SizedBox(height: 16),
            const Text(
              'Organize your tasks efficiently',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ).animate().slideY(begin: 1, duration: 800.ms).fadeIn(),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
