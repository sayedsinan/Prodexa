import '../models/auth_model.dart';
import '../models/user_model.dart';

abstract class IAuthRepository {
  Future<AuthModel> login({
    required String email,
    required String password,
  });

  Future<AuthModel> register({
    required String email,
    required String password,
  });

  Future<void> logout();
  
  Future<UserModel?> getCurrentUser();
  
  Future<bool> isLoggedIn();
  
  Future<String?> getStoredToken();
}