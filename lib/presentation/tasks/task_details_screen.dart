import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'task_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../users/user_dropdown.dart';
import '../../core/constants.dart';

class TaskFormScreen extends StatelessWidget {
  final bool isEdit;

  const TaskFormScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Create Task'),
        actions: [
          if (isEdit)
            IconButton(
              onPressed: () => taskController.deleteTask(taskController.selectedTask!.id),
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInput(
              controller: taskController.titleController,
              label: 'Task Title *',
              hint: 'Enter task title',
            ).animate().slideX(begin: -1, duration: 600.ms),
            
            const SizedBox(height: 16),
            
            CustomInput(
              controller: taskController.descriptionController,
              label: 'Description *',
              hint: 'Enter task description',
              maxLines: 3,
            ).animate().slideX(begin: 1, duration: 600.ms),
            
            const SizedBox(height: 16),
            
            CustomInput(
              controller: taskController.dueDateController,
              label: 'Due Date',
              hint: 'Select due date',
              readOnly: true,
              suffixIcon: Icons.calendar_today,
              onTap: () => _selectDate(context, taskController),
            ).animate().slideX(begin: -1, duration: 800.ms),
            
            const SizedBox(height: 16),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                  value: taskController.selectedPriority.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  items: AppConstants.priorityLevels.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      taskController.selectedPriority.value = value;
                    }
                  },
                )),
              ],
            ).animate().slideX(begin: 1, duration: 800.ms),
            
            const SizedBox(height: 16),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                  value: taskController.selectedStatus.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  items: AppConstants.taskStatuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      taskController.selectedStatus.value = value;
                    }
                  },
                )),
              ],
            ).animate().slideX(begin: -1, duration: 1000.ms),
            
            const SizedBox(height: 16),
            
            Obx(() => UserDropdown(
              selectedUserId: taskController.selectedUserId.value,
              onChanged: (userId) => taskController.selectedUserId.value = userId,
            )).animate().slideX(begin: 1, duration: 1000.ms),
            
            const SizedBox(height: 32),
            
            Obx(() => CustomButton(
              onPressed: taskController.isLoading 
                  ? null 
                  : isEdit 
                      ? taskController.updateTask 
                      : taskController.createTask,
              isLoading: taskController.isLoading,
              text: isEdit ? 'Update Task' : 'Create Task',
            )).animate().scale(delay: 600.ms),
            
            const SizedBox(height: 16),
            
            CustomButton(
              onPressed: () => Get.back(),
              text: 'Cancel',
              isOutlined: true,
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TaskController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.dueDateController.text.isNotEmpty
          ? DateTime.parse(controller.dueDateController.text)
          : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      controller.dueDateController.text = selectedDate.toIso8601String().split('T')[0];
    }
  }
}