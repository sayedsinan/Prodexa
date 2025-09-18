import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodexa/presentation/tasks/task_list_screen.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'presentation/auth/login_screen.dart';
import 'bindings/auth_binding.dart';
import 'bindings/task_binding.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.tasks,
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: AppRoutes.tasks,
          page: () => const TaskListScreen(),
          binding: TaskBinding(),
        ),
      ],
    );
  }
}
