import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController());
    controller.fetchTasks();

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (_, index) {
            final task = controller.tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text("Status: ${task.status}"),
            );
          },
        );
      }),
    );
  }
}
