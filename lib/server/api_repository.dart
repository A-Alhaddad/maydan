import 'package:maydan/server/api_service.dart';

class ApiRepository {
  ApiRepository({ApiService? apiService})
      : api = apiService ?? ApiService.instance;

  final ApiService api;

  Future<ApiResult<Map<String, dynamic>>> register({
    required String mobile,
    String role = 'player',
  }) {
    return api.request<Map<String, dynamic>>(
      path: '/auth/register',
      method: 'POST',
      data: {
        'mobile': mobile,
        'role': role,
      },
      decoder: _asMap,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> login({
    required String mobile,
  }) {
    return api.request<Map<String, dynamic>>(
      path: '/auth/login',
      method: 'POST',
      data: {
        'mobile': mobile,
      },
      decoder: _asMap,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> verifyOtp({
    required String mobile,
    required String otp,
  }) {
    return api.request<Map<String, dynamic>>(
      path: '/auth/verify-otp',
      method: 'POST',
      data: {
        'mobile': mobile,
        'otp': otp,
      },
      decoder: _asMap,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> me() {
    return api.request<Map<String, dynamic>>(
      path: '/auth/me',
      method: 'GET',
      auth: true,
      decoder: _asMap,
    );
  }

  Future<ApiResult<List<dynamic>>> getSports() {
    return api.request<List<dynamic>>(
      path: '/sports',
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getStadiums({
    String? city,
    int? sportId,
  }) {
    return api.request<List<dynamic>>(
      path: '/stadiums',
      query: {
        if (city != null) 'city': city,
        if (sportId != null) 'sport_id': sportId,
      },
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getCountries() {
    return api.request<List<dynamic>>(
      path: '/countries',
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getEvents({
    int? sportId,
    String? city,
    String? from,
    String? to,
  }) {
    return api.request<List<dynamic>>(
      path: '/events',
      query: {
        if (sportId != null) 'sport_id': sportId,
        if (city != null) 'city': city,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getMatches() {
    return api.request<List<dynamic>>(
      path: '/matches',
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getChallenges() {
    return api.request<List<dynamic>>(
      path: '/challenges',
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getProducts() {
    return api.request<List<dynamic>>(
      path: '/products',
      auth: true,
      decoder: _asList,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createReservation(
      Map<String, dynamic> body) {
    return api.request<Map<String, dynamic>>(
      path: '/reservations',
      method: 'POST',
      auth: true,
      data: body,
      decoder: _asMap,
    );
  }

  static List<dynamic> _asList(dynamic data) {
    if (data is List<dynamic>) return data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is List<dynamic>) {
        return data['data'] as List<dynamic>;
      }
    }
    return [];
  }

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return {};
  }
}
