import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/i_task_repository.dart';
import '../../domain/models/task_model.dart';
import '../../core/constants.dart';
import '../../core/app_routes.dart';

class TaskController extends GetxController {
  final ITaskRepository _taskRepository;

  TaskController(this._taskRepository);

  final _isLoading = false.obs;
  final _tasks = <TaskModel>[].obs;
  final _filteredTasks = <TaskModel>[].obs;
  final _selectedTask = Rxn<TaskModel>();
  final _searchQuery = ''.obs;
  final _selectedStatus = 'All'.obs;
  final _selectedPriority = 'All'.obs;
  final _taskStats = <String, int>{}.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final selectedPriority = 'Medium'.obs;
  final selectedStatus = 'To-Do'.obs;
  final selectedUserId = Rxn<int>();

  bool get isLoading => _isLoading.value;
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get filteredTasks => _filteredTasks;
  TaskModel? get selectedTask => _selectedTask.value;
  String get searchQuery => _searchQuery.value;
  String get selectedStatusFilter => _selectedStatus.value;
  String get selectedPriorityFilter => _selectedPriority.value;
  Map<String, int> get taskStats => _taskStats;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    loadTaskStatistics();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.onClose();
  }

  Future<void> loadTasks({bool forceRefresh = false}) async {
    try {
      _isLoading.value = true;
      
      final taskList = await _taskRepository.getTasks(forceRefresh: forceRefresh);
      _tasks.value = taskList;
      _applyFilters();
      
      await loadTaskStatistics();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tasks: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadTaskStatistics() async {
    try {
      final stats = await _taskRepository.getTaskStatistics();
      _taskStats.value = stats;
    } catch (e) {
      debugPrint('Error loading task statistics: $e');
    }
  }

  Future<void> createTask() async {
    if (!_validateTaskForm()) return;

    try {
      _isLoading.value = true;

      final task = TaskModel(
        id: 0, 
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: dueDateController.text.isNotEmpty
            ? DateTime.parse(dueDateController.text)
            : null,
        priority: selectedPriority.value,
        status: selectedStatus.value,
        assignedUserId: selectedUserId.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _taskRepository.createTask(task);
      
      Get.snackbar(
        'Success',
        AppConstants.taskCreatedMessage,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      _clearForm();
      Get.back();
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create task: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

 Future<void> updateTask() async {
  if (_selectedTask.value == null || !_validateTaskForm()) return;

  try {
    _isLoading.value = true;

    final updatedTask = _selectedTask.value!.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: dueDateController.text.isNotEmpty
          ? DateTime.parse(dueDateController.text)
          : null,
      priority: selectedPriority.value,
      status: selectedStatus.value,
      assignedUserId: selectedUserId.value,
      updatedAt: DateTime.now(),
    );

    await _taskRepository.updateTask(updatedTask);
    
    Get.snackbar(
      'Success',
      AppConstants.taskUpdatedMessage,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    _clearForm();
    Get.back();
    await loadTasks();
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to update task: ${e.toString().replaceAll('Exception: ', '')}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    _isLoading.value = false;
  }
}
  Future<void> deleteTask(int taskId) async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (result != true) return;

      _isLoading.value = true;
      
      await _taskRepository.deleteTask(taskId);
      
      Get.snackbar(
        'Success',
        AppConstants.taskDeletedMessage,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void selectTask(TaskModel task) {
    _selectedTask.value = task;
    _fillFormWithTask(task);
  }

  void _fillFormWithTask(TaskModel task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    dueDateController.text = task.dueDate?.toIso8601String().split('T')[0] ?? '';
    selectedPriority.value = task.priority;
    selectedStatus.value = task.status;
    selectedUserId.value = task.assignedUserId;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    selectedPriority.value = 'Medium';
    selectedStatus.value = 'To-Do';
    selectedUserId.value = null;
    _selectedTask.value = null;
  }

  bool _validateTaskForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Task title is required');
      return false;
    }
    
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Task description is required');
      return false;
    }
    
    return true;
  }

  void searchTasks(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  void filterByStatus(String status) {
    _selectedStatus.value = status;
    _applyFilters();
  }

  void filterByPriority(String priority) {
    _selectedPriority.value = priority;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _tasks.toList();

    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
               task.description.toLowerCase().contains(_searchQuery.value.toLowerCase());
      }).toList();
    }

    if (_selectedStatus.value != 'All') {
      filtered = filtered.where((task) => task.status == _selectedStatus.value).toList();
    }

    if (_selectedPriority.value != 'All') {
      filtered = filtered.where((task) => task.priority == _selectedPriority.value).toList();
    }

    _filteredTasks.value = filtered;
  }

  void navigateToTaskForm({bool isEdit = false}) {
    if (isEdit) {
      Get.toNamed(AppRoutes.editTask);
    } else {
      _clearForm();
      Get.toNamed(AppRoutes.taskForm);
    }
  }

  void navigateToTaskDetail(TaskModel task) {
    selectTask(task);
    Get.toNamed(AppRoutes.taskDetail);
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(
        completed: !task.completed,
        status: !task.completed ? 'Done' : 'To-Do',
        updatedAt: DateTime.now(),
      );

      await _taskRepository.updateTask(updatedTask);
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<TaskModel> getOverdueTasks() {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  List<TaskModel> getTasksDueToday() {
    return _tasks.where((task) => task.isDueToday).toList();
  }
}