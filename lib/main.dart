import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'data/local/hive_service.dart';
import 'bindings/auth_binding.dart';
import 'bindings/task_binding.dart';
import 'bindings/user_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        AuthBinding().dependencies();
        UserBinding().dependencies();
        TaskBinding().dependencies();
      }),
    );
  }
}