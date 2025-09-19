// presentation/tasks/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/auth_controller.dart';
import '../users/user_controller.dart';
import 'task_controller.dart';
import '../widgets/task_card.dart';
import '../../core/constants.dart';
import '../../core/app_routes.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final userController = Get.find<UserController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () => taskController.loadTasks(forceRefresh: true),
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: authController.logout,
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
          controller: _tabController,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.list)),
            Tab(text: 'To-Do', icon: Icon(Icons.radio_button_unchecked)),
            Tab(text: 'In Progress', icon: Icon(Icons.autorenew)),
            Tab(text: 'Done', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: 12,
                      ),
                    ),
                    onChanged: taskController.searchTasks,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilterDialog(context, taskController),
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),

          // Task Statistics Cards
          Obx(() {
            final stats = taskController.taskStats;
            if (stats.isEmpty) return const SizedBox.shrink();
            
            return Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Row(
                children: [
                  _buildStatCard('Total', stats['total'] ?? 0, Icons.task_alt, Colors.blue),
                  _buildStatCard('Pending', stats['pending'] ?? 0, Icons.pending, Colors.orange),
                  _buildStatCard('Completed', stats['completed'] ?? 0, Icons.done, Colors.green),
                  _buildStatCard('Overdue', stats['overdue'] ?? 0, Icons.warning, Colors.red),
                ],
              ),
            ).animate().slideY(begin: -0.5, duration: 500.ms);
          }),

          // Task List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(taskController, userController),
                _buildFilteredTaskList(taskController, userController, 'To-Do'),
                _buildFilteredTaskList(taskController, userController, 'In Progress'),
                _buildFilteredTaskList(taskController, userController, 'Done'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => taskController.navigateToTaskForm(),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskController taskController, UserController userController) {
    return Obx(() {
      if (taskController.isLoading && taskController.filteredTasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (taskController.filteredTasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first task to get started',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ).animate().fadeIn();
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

  Widget _buildFilteredTaskList(TaskController taskController, UserController userController, String status) {
    return Obx(() {
      // Filter tasks by the specific status
      final filteredTasks = taskController.filteredTasks.where((task) => task.status == status).toList();

      if (taskController.isLoading && filteredTasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (filteredTasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusIcon(status),
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No $status tasks',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                status == 'To-Do' 
                    ? 'All caught up! No pending tasks.' 
                    : status == 'In Progress'
                        ? 'No tasks in progress right now.'
                        : 'No completed tasks yet.',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn();
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

  void _showFilterDialog(BuildContext context, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Priority Filter
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
            // Status Filter
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
              _searchController.clear();
              Get.back();
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}