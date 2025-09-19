import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/core/constants.dart' show AppConstants;
import 'package:task_management_app/presentation/tasks/task_controller.dart';

class TaskFilterDialog extends StatelessWidget {
  final TaskController taskController;
  final TextEditingController searchController;

  const TaskFilterDialog({
    super.key,
    required this.taskController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tasks'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: taskController.selectedPriorityFilter,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: ['All', ...AppConstants.priorityLevels].map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                taskController.filterByPriority(value);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: taskController.selectedStatusFilter,
            decoration: const InputDecoration(labelText: 'Status'),
            items: ['All', ...AppConstants.taskStatuses].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                taskController.filterByStatus(value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            taskController.filterByPriority('All');
            taskController.filterByStatus('All');
            taskController.searchTasks('');
            searchController.clear();
            Get.back();
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}