import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/core/constants.dart';
import 'package:task_management_app/presentation/tasks/task_controller.dart';
import 'package:task_management_app/presentation/users/user_controller.dart';
import 'package:task_management_app/presentation/widgets/empty_task.dart';
import 'package:task_management_app/presentation/widgets/task_card.dart';

class TaskListView extends StatelessWidget {
  final TaskController taskController;
  final UserController userController;

  const TaskListView({
    super.key,
    required this.taskController,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (taskController.isLoading && taskController.filteredTasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (taskController.filteredTasks.isEmpty) {
        return const EmptyTasksView(
          icon: Icons.task_alt,
          title: 'No tasks found',
          subtitle: 'Create your first task to get started',
        );
      }

      return RefreshIndicator(
        onRefresh: () => taskController.loadTasks(forceRefresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: taskController.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = taskController.filteredTasks[index];
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
            );
          },
        ),
      );
    });
  }
}
