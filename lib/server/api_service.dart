import 'package:dio/dio.dart';
import 'package:maydan/services/preferences/app_preferences.dart';
import 'package:maydan/value/constant.dart';

class ApiResult<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResult({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

class ApiService {
  ApiService._internal() {
    _initDio();
  }

  static final ApiService instance = ApiService._internal();

  final AppPreferences _prefs = AppPreferences();
  final _defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  String _baseHost = 'http://ec2-100-27-245-250.compute-1.amazonaws.com';
  String _authToken = '';
  late Dio _dio;

  String get baseUrl => '$_baseHost/api/v1';

  void configureBaseHost(String host) {
    _baseHost = host;
    _initDio();
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  Future<ApiResult<T>> request<T>({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    bool auth = false,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          method: method,
          headers: _buildHeaders(auth: auth),
        ),
      );

      final payload =
          decoder != null ? decoder(response.data) : response.data as T;

      return ApiResult(
        success: true,
        data: payload,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = _resolveErrorMessage(e);
      printLog('API error [$method $path]: ${e.response?.data ?? e.message}');
      return ApiResult(
        success: false,
        message: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      printLog('API error [$method $path]: $e');
      return ApiResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 30),
        headers: _buildHeaders(),
      ),
    );
  }

  Map<String, String> _buildHeaders({bool auth = false}) {
    final headers = <String, String>{};
    headers.addAll(_defaultHeaders);
    headers['Accept-Language'] = _prefs.getLanguageCode;

    final token = _authToken.isNotEmpty ? _authToken : _prefs.getTokenUser;
    if (auth && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  String _resolveErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final map = e.response!.data as Map<String, dynamic>;
      if (map['message'] != null) return map['message'].toString();
      if (map['error'] != null) return map['error'].toString();
    }
    if (e.message != null) return e.message!;
    return 'Network error';
  }
}
