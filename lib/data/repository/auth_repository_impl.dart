import 'package:logger/logger.dart';
import '../../domain/repository/i_auth_repository.dart';
import '../../domain/models/auth_model.dart';
import '../../domain/models/user_model.dart';
import '../api/auth_api.dart';
import '../local/hive_service.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApi _authApi;
  final Logger _logger = Logger();

  AuthRepositoryImpl(this._authApi);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.login(email: email, password: password);
      
    
      final token = response['token'] as String;
  
      final user = UserModel(
        id: 1, 
        email: email,
        firstName: 'User',
        lastName: 'Name',
        avatar: null,
      );

      final authModel = AuthModel(token: token, user: user);


      await HiveService.saveToken(token);
      await HiveService.saveUserData(user);

      _logger.i('Login successful for user: $email');
      return authModel;
    } catch (e) {
      _logger.e('Login failed: $e');
      rethrow;
    }
  }

  @override
  Future<AuthModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.register(email: email, password: password);
      
      final token = response['token'] as String;
    
      final user = UserModel(
        id: response['id'] ?? 1,
        email: email,
        firstName: 'New',
        lastName: 'User',
        avatar: null,
      );

      final authModel = AuthModel(token: token, user: user);

      await HiveService.saveToken(token);
      await HiveService.saveUserData(user);

      _logger.i('Registration successful for user: $email');
      return authModel;
    } catch (e) {
      _logger.e('Registration failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await HiveService.removeToken();
      await HiveService.removeUserData();
      await HiveService.clearTasks();
      await HiveService.clearUsers();
      
      _logger.i('Logout successful');
    } catch (e) {
      _logger.e('Logout failed: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return HiveService.getUserData();
    } catch (e) {
      _logger.e('Failed to get current user: $e');
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return HiveService.isLoggedIn;
    } catch (e) {
      _logger.e('Failed to check login status: $e');
      return false;
    }
  }

  @override
  Future<String?> getStoredToken() async {
    try {
      return HiveService.getToken();
    } catch (e) {
      _logger.e('Failed to get stored token: $e');
      return null;
    }
  }
}