// TODO Implement this library.
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:maydan/server/auth_server.dart';
import 'package:maydan/server/server_user.dart';
import '../widgets/my_library.dart';

class AppGet extends GetxController {
  static AppGet get to => Get.put(AppGet());

  String urlWebApp = 'https://google.com';
  int indexBodyHome = 0;

}
