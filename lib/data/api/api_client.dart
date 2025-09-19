import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConstants.baseAuthUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer ${AppConstants.apiKey}', // 👈 API KEY HERE
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('➡️ Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('✅ Response: ${response.statusCode} ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('❌ Error: ${error.response?.statusCode} ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  /// Dynamically update auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Connectivity check
  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureNetwork(path);
    try {
      return await _dio.get(path,
          queryParameters: queryParameters, options: options);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureNetwork(path);
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureNetwork(path);
    try {
      return await _dio.put(path,
          data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureNetwork(path);
    try {
      return await _dio.delete(path,
          data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Ensure network before request
  Future<void> _ensureNetwork(String path) async {
    if (!await hasNetworkConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: AppConstants.networkErrorMessage,
        type: DioExceptionType.connectionError,
      );
    }
  }

  /// Centralized error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('⏳ Connection timeout. Please try again.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ??
              error.response?.data?['error'] ??
              'Server error occurred';
          return Exception('HTTP $statusCode: $message');
        case DioExceptionType.cancel:
          return Exception('⚠️ Request was cancelled');
        default:
          return Exception(AppConstants.unknownErrorMessage);
      }
    }
    return Exception(error.toString());
  }
}
