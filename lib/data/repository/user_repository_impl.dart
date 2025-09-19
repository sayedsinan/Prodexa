// data/repository/user_repository_impl.dart
import 'package:logger/logger.dart';
import '../../domain/repository/i_user_repository.dart';
import '../../domain/models/user_model.dart';
import '../api/user_api.dart';
import '../api/api_client.dart';
import '../local/hive_service.dart';
import '../local/db_helper.dart';

class UserRepositoryImpl implements IUserRepository {
  final UserApi _userApi;
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  UserRepositoryImpl(this._userApi, this._apiClient);

  @override
  Future<List<UserModel>> getUsers({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || !await _apiClient.hasNetworkConnection()) {
        return _getUsersFromLocal();
      }

      try {
        // Fetch from API
        final users = await _userApi.getUsers();
        
        // Cache locally
        await DbHelper.saveUsersWithErrorHandling(users);
        
        _logger.i('Fetched ${users.length} users from API');
        return users;
      } catch (e) {
        _logger.w('API fetch failed, falling back to local data: $e');
        return _getUsersFromLocal();
      }
    } catch (e) {
      _logger.e('Failed to get users: $e');
      return [];
    }
  }

  List<UserModel> _getUsersFromLocal() {
    final users = HiveService.getUsers();
    _logger.i('Retrieved ${users.length} users from local storage');
    return users;
  }

  @override
  Future<UserModel> getUser(int id, {bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final localUser = HiveService.getUser(id);
        if (localUser != null) {
          _logger.i('Retrieved user $id from local storage');
          return localUser;
        }
      }

      if (await _apiClient.hasNetworkConnection()) {
        try {
          final user = await _userApi.getUser(id);
          await HiveService.saveUser(user);
          _logger.i('Fetched user $id from API');
          return user;
        } catch (e) {
          _logger.w('API fetch failed for user $id: $e');
        }
      }

      // Fallback to local
      final localUser = HiveService.getUser(id);
      if (localUser != null) {
        return localUser;
      }

      throw Exception('User not found');
    } catch (e) {
      _logger.e('Failed to get user $id: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUserFromLocal(int id) async {
    try {
      return HiveService.getUser(id);
    } catch (e) {
      _logger.e('Failed to get user from local: $e');
      return null;
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      await HiveService.saveUsers(users);
      _logger.i('Cached ${users.length} users locally');
    } catch (e) {
      _logger.e('Failed to cache users: $e');
      rethrow;
    }
  }
}