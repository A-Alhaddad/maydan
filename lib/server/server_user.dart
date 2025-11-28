import 'package:dio/dio.dart';
import 'package:get/get.dart' as myGet;
import 'package:maydan/server/app_get.dart';

class ServerUser {
  ServerUser._();

  static ServerUser serverUser = ServerUser._();

  AppGet appGet = myGet.Get.find();
  String baseUrl = '${AppGet.to.urlWebApp}/api/v1';

  Dio dio = Dio();

  initDio() {
    dio = Dio();
    return dio;
  }

}
