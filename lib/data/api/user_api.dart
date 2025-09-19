import '../api/api_client.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants.dart';

class UserApi {
  final ApiClient _apiClient;

  UserApi(this._apiClient);

  Future<List<UserModel>> getUsers({int page = 1, int perPage = 12}) async {
    final response = await _apiClient.get(
      AppConstants.usersEndpoint,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response.data as Map<String, dynamic>;
    final users = (data['data'] as List)
        .map((user) => UserModel.fromJson(user))
        .toList();

    return users;
  }

  Future<UserModel> getUser(int userId) async {
    final response = await _apiClient.get(
      '${AppConstants.usersEndpoint}/$userId',
    );
    return UserModel.fromJson(response.data['data']);
  }
}
