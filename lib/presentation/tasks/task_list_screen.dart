import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_management_app/presentation/widgets/app_bar.dart';
import 'package:task_management_app/presentation/widgets/task_filter_bar.dart';
import 'package:task_management_app/presentation/widgets/task_filter_dialoug.dart';
import 'package:task_management_app/presentation/widgets/task_tab_bar.dart';
import '../auth/auth_controller.dart';
import '../users/user_controller.dart';
import '../widgets/task_stat_section.dart';
import 'task_controller.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final userController = Get.find<UserController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: TaskListAppBar(
        onRefresh: () => taskController.loadTasks(forceRefresh: true),
        onLogout: authController.logout,
        tabController: _tabController,
      ),
      body: Column(
        children: [
          SearchAndFilterBar(
            searchController: _searchController,
            onSearch: taskController.searchTasks,
            onFilter: () => _showFilterDialog(context, taskController),
          ),
          const TaskStatisticsSection(),
          Expanded(
            child: TaskTabView(
              tabController: _tabController,
              taskController: taskController,
              userController: userController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => taskController.navigateToTaskForm(),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ).animate().scale(delay: 500.ms),
    );
  }

  void _showFilterDialog(BuildContext context, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) => TaskFilterDialog(
        taskController: taskController,
        searchController: _searchController,
      ),
    );
  }
}