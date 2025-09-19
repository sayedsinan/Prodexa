import 'package:flutter/material.dart';
class TaskListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final VoidCallback onLogout;
  final TabController tabController;

  const TaskListAppBar({
    super.key,
    required this.onRefresh,
    required this.onLogout,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Tasks'),
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onLogout,
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'All', icon: Icon(Icons.list)),
          Tab(text: 'To-Do', icon: Icon(Icons.radio_button_unchecked)),
          Tab(text: 'In Progress', icon: Icon(Icons.autorenew)),
          Tab(text: 'Done', icon: Icon(Icons.check_circle)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
