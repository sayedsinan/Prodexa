import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants.dart';

class HiveService {
  static late Box<TaskModel> _tasksBox;
  static late Box<UserModel> _usersBox;
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    
    _prefs = await SharedPreferences.getInstance();
    

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    _tasksBox = await Hive.openBox<TaskModel>(AppConstants.tasksBoxKey);
    _usersBox = await Hive.openBox<UserModel>(AppConstants.usersBoxKey);
  }


  static Future<void> saveTasks(List<TaskModel> tasks) async {
    await _tasksBox.clear();
    for (final task in tasks) {
      await _tasksBox.put(task.id, task);
    }
  }

  static Future<void> saveTask(TaskModel task) async {
    await _tasksBox.put(task.id, task);
  }

  static List<TaskModel> getTasks() {
    return _tasksBox.values.toList();
  }

  static TaskModel? getTask(int id) {
    return _tasksBox.get(id);
  }

  static Future<void> deleteTask(int id) async {
    await _tasksBox.delete(id);
  }

  static Future<void> clearTasks() async {
    await _tasksBox.clear();
  }

  static Future<void> saveUsers(List<UserModel> users) async {
    await _usersBox.clear();
    for (final user in users) {
      await _usersBox.put(user.id, user);
    }
  }

  static Future<void> saveUser(UserModel user) async {
    await _usersBox.put(user.id, user);
  }

  static List<UserModel> getUsers() {
    return _usersBox.values.toList();
  }

  static UserModel? getUser(int id) {
    return _usersBox.get(id);
  }

  static Future<void> clearUsers() async {
    await _usersBox.clear();
  }

   
  static Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  static Future<void> removeToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  static Future<void> saveUserData(UserModel user) async {
    final userData = user.toJson();
    for (final entry in userData.entries) {
      if (entry.value is String) {
        await _prefs.setString('${AppConstants.userKey}_${entry.key}', entry.value);
      } else if (entry.value is int) {
        await _prefs.setInt('${AppConstants.userKey}_${entry.key}', entry.value);
      }
    }
  }

  static UserModel? getUserData() {
    final id = _prefs.getInt('${AppConstants.userKey}_id');
    if (id == null) return null;

    return UserModel(
      id: id,
      email: _prefs.getString('${AppConstants.userKey}_email') ?? '',
      firstName: _prefs.getString('${AppConstants.userKey}_first_name') ?? '',
      lastName: _prefs.getString('${AppConstants.userKey}_last_name') ?? '',
      avatar: _prefs.getString('${AppConstants.userKey}_avatar'),
    );
  }

  static Future<void> removeUserData() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(AppConstants.userKey));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  static Future<void> clearAll() async {
    await _tasksBox.clear();
    await _usersBox.clear();
    await _prefs.clear();
  }

  static bool get isLoggedIn => getToken() != null && getUserData() != null;
}

