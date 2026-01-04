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

  Future<dynamic> getCountries() async {
    try {
      initDio();
      String url = baseUrl + '/countries';
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': 'ar',
      };

      print('url = $url');
      Response response =
          await dio.get(url, options: Options(headers: headers));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        // appGet.countries.value = response.data['data'];
        print('appGet.countries.value ${appGet.countries.toString()}');
      } else {
        print("loginUserUrl ${response.data}");
        return {
          'code': 466,
          'data': response.data,
          'status': false,
          'message': 'Error'
        };
      }
    } on DioError catch (e) {
      print('error loginUserUrl ${e.response?.data ?? ''}');
      if (e.response?.data == null) {
        return {
          'code': 455,
          'data': '',
          'status': false,
          'message': 'Internet'
        };
      } else {
        return {
          'data': e.response!.data,
          'status': false,
          'message': e.response?.data['message']
        };
      }
    }
  }
}
