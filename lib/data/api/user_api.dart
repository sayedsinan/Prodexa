import 'api_client.dart';
import '../../core/constants.dart';

class UserApi extends ApiClient {
  Future<List<dynamic>> getUsers() async {
    final response = await dio.get("${AppConstants.baseUrlReqres}/users");
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await dio.get("${AppConstants.baseUrlReqres}/users/$id");
    return response.data['data'];
  }
}
