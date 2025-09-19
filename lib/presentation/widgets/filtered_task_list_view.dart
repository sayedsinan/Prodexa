import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:task_management_app/core/constants.dart';
import 'package:task_management_app/presentation/tasks/task_controller.dart';
import 'package:task_management_app/presentation/users/user_controller.dart';
import 'package:task_management_app/presentation/widgets/empty_task.dart';
import 'package:task_management_app/presentation/widgets/task_card.dart';

class FilteredTaskListView extends StatelessWidget {
  final TaskController taskController;
  final UserController userController;
  final String status;

  const FilteredTaskListView({
    super.key,
    required this.taskController,
    required this.userController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredTasks = taskController.filteredTasks
          .where((task) => task.status == status)
          .toList();

      if (taskController.isLoading && filteredTasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (filteredTasks.isEmpty) {
        return EmptyTasksView(
          icon: _getStatusIcon(status),
          title: 'No $status tasks',
          subtitle: _getEmptyMessage(status),
        );
      }

      return RefreshIndicator(
        onRefresh: () => taskController.loadTasks(forceRefresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            final assignedUser = userController.getUserById(task.assignedUserId);
            
            return TaskCard(
              task: task,
              assignedUserName: assignedUser?.fullName,
              onTap: () => taskController.navigateToTaskDetail(task),
              onEdit: () {
                taskController.selectTask(task);
                taskController.navigateToTaskForm(isEdit: true);
              },
              onDelete: () => taskController.deleteTask(task.id),
              onToggleComplete: () => taskController.toggleTaskCompletion(task),
            ).animate()
                .slideX(begin: 0.1, duration: 300.ms, delay: (index * 50).ms)
                .fadeIn(duration: 400.ms, delay: (index * 50).ms);
          },
        ),
      );
    });
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'To-Do':
        return Icons.radio_button_unchecked;
      case 'In Progress':
        return Icons.autorenew;
      case 'Done':
        return Icons.check_circle;
      default:
        return Icons.task_alt;
    }
  }

  String _getEmptyMessage(String status) {
    switch (status) {
      case 'To-Do':
        return 'All caught up! No pending tasks.';
      case 'In Progress':
        return 'No tasks in progress right now.';
      case 'Done':
        return 'No completed tasks yet.';
      default:
        return 'No tasks available.';
    }
  }
}
