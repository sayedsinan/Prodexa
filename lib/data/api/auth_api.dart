import 'api_client.dart';
import '../../core/constants.dart';

class AuthApi extends ApiClient {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      "${AppConstants.baseUrlReqres}/login",
      data: {"email": email, "password": password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await dio.post(
      "${AppConstants.baseUrlReqres}/register",
      data: {"email": email, "password": password},
    );
    return response.data;
  }
}
