import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maydan/value/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher {
  Launcher._();

  static final Launcher launcher = Launcher._();

  launchPhone(String phone) async {
    // launch('tel:${phone.toString()}');
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(launchUri);
  }

  launchWhatsapp(
      {required String phone,
      required BuildContext context,
      String massage = 'Hello'}) async {
    String massageWhatsapp = massage;
    String numberPhone =
        phone.substring(0, 2) == '00' ? '+${phone.substring(2)}' : phone;
    var androidUrl = "whatsapp://send?phone=$numberPhone&text=$massageWhatsapp";
    var iosUrl =
        "https://wa.me/$numberPhone?text=${Uri.parse('$massageWhatsapp')}";
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      messageError(
          title: 'خطأ',
          bodyString: 'يبدو انك لم تقم بتثبيت الواتساب على هاتفك'.tr,
          cancelText: 'اغلاق'.tr,
          context: context);
    }
  }

  launchEmail(String email) {
    // launch('mailto:$email');
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Lateeef App',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  launchURL(String url, {bool inApp = false}) async {
    // launch('$url');
    late Uri _url;
    if (url.toLowerCase().contains('http://')) {
      String newUrl = url.replaceAll('http://', 'https://');
      _url = Uri.parse(newUrl);
    } else if (url.toLowerCase().contains('https://')) {
      _url = Uri.parse(url);
    } else {
      _url = Uri.parse('https://$url');
    }
    if (!await launchUrl(
      _url,
      mode:
          !inApp ? LaunchMode.externalApplication : LaunchMode.inAppBrowserView,
    )) {
      throw 'Could not launch $_url';
    }
  }

  sendEmail({required String email , required String subject}){
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );

    launchUrl(emailLaunchUri);
  }
}
