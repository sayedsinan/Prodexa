import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';

class UserDropdown extends StatelessWidget {
  final Function(int) onSelected;
  const UserDropdown({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    controller.fetchUsers();

    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }
      return DropdownButtonFormField<int>(
        items: controller.users
            .map((u) => DropdownMenuItem<int>(
                  value: u.id,
                  child: Text(u.fullName),
                ))
            .toList(),
        onChanged: (value) => onSelected(value!),
        decoration: const InputDecoration(labelText: "Assign User"),
      );
    });
  }
}
