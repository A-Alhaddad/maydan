// TODO Implement this library.
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:maydan/server/auth_server.dart';
import 'package:maydan/server/server_user.dart';
import '../widgets/my_library.dart';

class AppGet extends GetxController {
  static AppGet get to => Get.put(AppGet());
  late Locale appLocale;
  String? otpErrorMessage;
  String isValidCode = "123456";
  @override
  void onInit() {
    super.onInit();
    initLanguage(); // ← فحص اللغة أول ما يشتغل الكنترولر
  }

  void initLanguage() {
    final langCode = AppPreferences().getLanguageCode;
    final countryCode = AppPreferences().getCountryCode;
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
  }

  Future<void> changeLanguage(String langCode, String countryCode) async {
    await AppPreferences()
        .saveLocale(countryCode: countryCode, languageCode: langCode);
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
    update();
  }

  String urlWebApp = 'https://google.com';
  int indexBodyHome = 0;

  afterLoginOrRegister(
      {bool fromLogin = false,
      bool fromRegister = false,
      bool fromChangePassword = false}) {
    // Get.offAll(()=>Home());
  }
}
