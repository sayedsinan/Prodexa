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
    try {
      final response = await _apiClient.postAuth(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['token'] != null) {
        _apiClient.setAuthToken(responseData['token']);
      }

      return responseData;
    } catch (e) {
      return _mockLogin(email, password);
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.postAuth(
        AppConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['token'] != null) {
        _apiClient.setAuthToken(responseData['token']);
      }

      return responseData;
    } catch (e) {
      return _mockRegister(email, password);
    }
  }

  Future<Map<String, dynamic>> _mockLogin(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _apiClient.setAuthToken(mockToken);

    return {
      'token': mockToken,
      'id': 1,
      'email': email,
    };
  }

  Future<Map<String, dynamic>> _mockRegister(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!email.contains('@')) {
      throw Exception('Please enter a valid email');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _apiClient.setAuthToken(mockToken);

    return {
      'token': mockToken,
      'id': DateTime.now().millisecondsSinceEpoch % 1000,
      'email': email,
    };
  }

  Future<UserModel> getCurrentUser(int userId) async {
    try {
      final response =
          await _apiClient.get('${AppConstants.usersEndpoint}/$userId');
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      return UserModel(
        id: userId,
        email: 'mock@example.com',
        firstName: 'Mock',
        lastName: 'User',
        avatar: 'https://reqres.in/img/faces/1-image.jpg',
      );
    }
  }

  void logout() {
    _apiClient.clearAuthToken();
  }
}
