import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/user_model.dart';
import 'user_controller.dart';
import '../../core/constants.dart';

class UserDropdown extends StatelessWidget {
  final int? selectedUserId;
  final Function(int?) onChanged;
  final String label;
  final bool enabled;

  const UserDropdown({
    super.key,
    this.selectedUserId,
    required this.onChanged,
    this.label = 'Assigned User',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (userController.isLoading && userController.users.isEmpty) {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return DropdownButtonFormField<int>(
            value: selectedUserId,
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              hintText: 'Select a user',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('Unassigned'),
              ),
              ...userController.users.map((UserModel user) {
                return DropdownMenuItem<int>(
                  value: user.id,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: user.avatar != null 
                            ? NetworkImage(user.avatar!) 
                            : null,
                        child: user.avatar == null 
                            ? Text(
                                user.firstName[0].toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ) 
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user.fullName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
} 