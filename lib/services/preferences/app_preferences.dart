import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _sharedPreferences;

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> saveStringValue(
      {required String value, required String key}) async {
    await _sharedPreferences.setString(key, value);
  }

  Future<void> saveBoolValue({required bool value, required String key}) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<String> getStringValue({required String key}) async {
    String value = await _sharedPreferences.getString(key) ??'';
    return value;
  }

  Future<bool> getBoolValue({required String key}) async {
    bool value = await _sharedPreferences.getBool(key) ??false;
    return value;
  }

  Future<void> saveLocale({required String languageCode , required String countryCode}) async {
    await _sharedPreferences.setString('languageCode', languageCode);
    await _sharedPreferences.setString('countryCode', countryCode);
  }

  String get getLanguageCode => _sharedPreferences.getString('languageCode') ?? 'ar';
  String get getCountryCode => _sharedPreferences.getString('countryCode') ?? 'AE';
  String get getTokenUser => _sharedPreferences.getString('tokenUser') ?? '';

  bool get getStateLogin => _sharedPreferences.getBool('isLogin') ?? false;

  Future<void> logOut() async {
    await _sharedPreferences.clear();
  }
}