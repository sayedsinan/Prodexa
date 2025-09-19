import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:task_management_app/core/constants.dart';
import 'package:task_management_app/presentation/tasks/task_controller.dart';
import 'package:task_management_app/presentation/widgets/task_stat_card.dart';

class TaskStatisticsSection extends StatelessWidget {
  const TaskStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Obx(() {
      final stats = taskController.taskStats;
      if (stats.isEmpty) return const SizedBox.shrink();
      
      return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        child: Row(
          children: [
            TaskStatCard(
              label: 'Total',
              value: stats['total'] ?? 0,
              icon: Icons.task_alt,
              color: Colors.blue,
            ),
            TaskStatCard(
              label: 'Pending',
              value: stats['pending'] ?? 0,
              icon: Icons.pending,
              color: Colors.orange,
            ),
            TaskStatCard(
              label: 'Completed',
              value: stats['completed'] ?? 0,
              icon: Icons.done,
              color: Colors.green,
            ),
            TaskStatCard(
              label: 'Overdue',
              value: stats['overdue'] ?? 0,
              icon: Icons.warning,
              color: Colors.red,
            ),
          ],
        ),
      ).animate().slideY(begin: -0.5, duration: 500.ms);
    });
  }
}

