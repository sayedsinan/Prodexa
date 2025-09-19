import 'package:get/get.dart';

import '../presentation/auth/login_screen.dart';
import '../presentation/auth/register_screen.dart';
import '../presentation/tasks/task_list_screen.dart';

import '../presentation/tasks/task_form_screen.dart';
import '../presentation/splash_screen.dart';
import '../bindings/auth_binding.dart';
import '../bindings/task_binding.dart';
import '../bindings/user_binding.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String taskList = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String taskForm = '/task-form';
  static const String editTask = '/edit-task';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: taskList,
      page: () => const TaskListScreen(),
      bindings: [
        TaskBinding(),
        UserBinding(),
      ],
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: taskDetail,
    //   page: () => const Task(),
    //   binding: TaskBinding(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: taskForm,
      page: () => const TaskFormScreen(),
      bindings: [
        TaskBinding(),
        UserBinding(),
      ],
      transition: Transition.downToUp,
    ),
    GetPage(
      name: editTask,
      page: () => const TaskFormScreen(isEdit: true),
      bindings: [
        TaskBinding(),
        UserBinding(),
      ],
      transition: Transition.rightToLeft,
    ),
  ];
}