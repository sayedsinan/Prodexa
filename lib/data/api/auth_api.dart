// data/api/auth_api.dart
import '../api/api_client.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      AppConstants.loginEndpoint,
      
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      AppConstants.registerEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<UserModel> getCurrentUser(int userId) async {
    final response = await _apiClient.get('${AppConstants.usersEndpoint}/$userId');
    return UserModel.fromJson(response.data['data']);
  }
}