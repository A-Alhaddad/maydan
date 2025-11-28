import 'package:dio/dio.dart';
import 'package:get/get.dart' as myGet;
import 'package:maydan/server/app_get.dart';

class AuthServer {
  String baseUrl = '${AppGet.to.urlWebApp}/api/v1';

  AuthServer._();

  static AuthServer authServer = AuthServer._();

  AppGet appGet = myGet.Get.find();

  Dio dio = Dio();

  initDio() {
    dio = Dio();
    return dio;
  }

  /////////////////////////Login///////////////////////

  Future<dynamic> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      initDio();
      // SVProgressHUD.show();
      // String fcm = await FbNotifications.getFcm();
      String url = baseUrl + '/auth/login';
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': 'ar' ,
      };
      // print('=====>fcm $fcm');
      var formData = FormData.fromMap({
        'email': email.toString().trim(),
        'password': password,
        // "fcm_token": fcm
      });

      print('url = $url');
      Response response = await dio.post(url,
          data: formData, options: Options(headers: headers));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // requiredData();
        // AppPreferences()
        //     .saveBoolValue(value: true, key: 'isLogin');
        // AppPreferences().saveStringValue(
        //     value: response.data['data']['token'], key: 'tokenUser');
        // return {'data': response.data, 'status': true, 'message': 'Success'};
      } else {
        print("loginUserUrl ${response.data}");
        return {'code': 466,'data': response.data, 'status': false, 'message': 'Error'};
      }
    } on DioError catch (e) {
      print('error loginUserUrl ${e.response?.data ?? ''}');
      if (e.response?.data == null) {
        return {'code': 455,'data': '', 'status': false, 'message': 'Internet'};
      } else {
        return {'data': e.response!.data, 'status': false, 'message': e.response?.data['message']};
      }
    }
  }

}