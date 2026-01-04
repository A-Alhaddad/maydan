import 'package:maydan/server/api_service.dart';

class ApiRepository {
  ApiRepository({ApiService? apiService})
      : api = apiService ?? ApiService.instance;

  final ApiService api;

  Future<ApiResult<Map<String, dynamic>>> register({
    required String mobile,
    String role = 'player',
    String? name,
    String? countryId,
  }) {
    return api.request<Map<String, dynamic>>(
      path: '/auth/register',
      method: 'POST',
      data: {
        'mobile': mobile,
        'role': role,
        if (name != null && name.isNotEmpty) 'name': name,
        if (countryId != null && countryId.isNotEmpty) 'country_id': countryId,
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

  Future<ApiResult<Map<String, dynamic>>> getProfile() {
    return api.request<Map<String, dynamic>>(
      path: '/profile',
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
    String? countryId,
    String? cityId,
    int? sportId,
    double? lat,
    double? lng,
  }) {
    return api.request<List<dynamic>>(
      path: '/stadiums',
      query: {
        if (countryId != null) 'country_id': countryId,
        if (cityId != null) 'city_id': cityId,
        if (sportId != null) 'sport_id': sportId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
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

  Future<ApiResult<List<dynamic>>> getCitiesByCountry(String countryId) {
    return api.request<List<dynamic>>(
      path: '/countries/$countryId/cities',
      decoder: _asList,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateProfile(
      dynamic body, {bool multipart = false}) {
    return api.request<Map<String, dynamic>>(
      path: '/profile',
      method: 'POST',
      auth: true,
      data: body,
      multipart: multipart,
      decoder: (data) {
        if (data is Map<String, dynamic>) {
          return data;
        }
        return {};
      },
    );
  }

  Future<ApiResult<List<dynamic>>> getEvents({
    int? sportId,
    String? countryId,
    String? cityId,
    String? from,
    String? to,
    double? lat,
    double? lng,
  }) {
    return api.request<List<dynamic>>(
      path: '/events',
      query: {
        if (countryId != null) 'country_id': countryId,
        if (sportId != null) 'sport_id': sportId,
        if (cityId != null) 'city_id': cityId,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getMatches({
    String? countryId,
    String? cityId,
    int? sportId,
    double? lat,
    double? lng,
  }) {
    return api.request<List<dynamic>>(
      path: '/matches',
      query: {
        if (countryId != null) 'country_id': countryId,
        if (cityId != null) 'city_id': cityId,
        if (sportId != null) 'sport_id': sportId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getChallenges({
    String? countryId,
    String? cityId,
    int? sportId,
    double? lat,
    double? lng,
  }) {
    return api.request<List<dynamic>>(
      path: '/challenges',
      query: {
        if (countryId != null) 'country_id': countryId,
        if (cityId != null) 'city_id': cityId,
        if (sportId != null) 'sport_id': sportId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
      decoder: _asList,
    );
  }

  Future<ApiResult<List<dynamic>>> getTrainers({
    String? countryId,
    String? cityId,
    int? sportId,
    double? lat,
    double? lng,
  }) {
    return api.request<List<dynamic>>(
      path: '/trainers',
      query: {
        if (countryId != null) 'country_id': countryId,
        if (cityId != null) 'city_id': cityId,
        if (sportId != null) 'sport_id': sportId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
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
