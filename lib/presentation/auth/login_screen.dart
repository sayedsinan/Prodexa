import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'auth_controller.dart';
import '../../core/app_routes.dart';
import '../../core/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Column(
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ).animate().scale(duration: 600.ms),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ).animate().slideY(begin: 1, duration: 600.ms),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ).animate().slideY(begin: 1, duration: 800.ms),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomInput(
                            controller: controller.emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                          ).animate().slideX(begin: -1, duration: 600.ms),
                          const SizedBox(height: 16),
                          CustomInput(
                            controller: controller.passwordController,
                            label: 'Password',
                            obscureText: true,
                            prefixIcon: Icons.lock_outlined,
                          ).animate().slideX(begin: 1, duration: 600.ms),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: controller.fillDemoCredentials,
                              child: const Text('Use Demo Credentials'),
                            ),
                          ).animate().fadeIn(delay: 800.ms),
                          const SizedBox(height: 24),
                          Obx(() => CustomButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : controller.login,
                                isLoading: controller.isLoading,
                                text: 'Sign In',
                              )).animate().scale(delay: 600.ms),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.register),
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ).animate().fadeIn(delay: 1000.ms),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
