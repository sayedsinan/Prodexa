import 'package:flutter/material.dart';
import 'package:task_management_app/presentation/tasks/task_controller.dart';
import 'package:task_management_app/presentation/users/user_controller.dart';
import 'package:task_management_app/presentation/widgets/filtered_task_list_view.dart';
import 'package:task_management_app/presentation/widgets/task_list_view.dart';

class TaskTabView extends StatelessWidget {
  final TabController tabController;
  final TaskController taskController;
  final UserController userController;

  const TaskTabView({
    super.key,
    required this.tabController,
    required this.taskController,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        TaskListView(
          taskController: taskController,
          userController: userController,
        ),
        FilteredTaskListView(
          taskController: taskController,
          userController: userController,
          status: 'To-Do',
        ),
        FilteredTaskListView(
          taskController: taskController,
          userController: userController,
          status: 'In Progress',
        ),
        FilteredTaskListView(
          taskController: taskController,
          userController: userController,
          status: 'Done',
        ),
      ],
    );
  }
}