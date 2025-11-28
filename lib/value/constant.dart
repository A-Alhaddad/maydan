import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/my_library.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:logger/logger.dart';
import 'package:universal_platform/universal_platform.dart';

hiddenKeyboard(BuildContext context) {
  printLog('hiddenKeyboard');
  FocusScope.of(context).requestFocus(FocusNode());
}




messageError(
    {required String title,
    required String bodyString,
    required String cancelText,
    required BuildContext context}) {
  Get.snackbar(
    '',
    '',
    titleText: Text(title , style: GoogleFonts.ibmPlexSansArabic(fontSize: 18.sp, color: AppColors.white ,fontWeight: FontWeight.bold),),
    messageText: Text(bodyString , style: GoogleFonts.ibmPlexSansArabic(fontSize: 16.sp, color: AppColors.white ,fontWeight: FontWeight.normal),),
    colorText: Colors.white,
    backgroundColor: Colors.red,
    icon: const Icon(Icons.add_alert ,color: AppColors.white,),
  );
}

messageSUCCESS(
    {required String title,
      required String bodyString,
      required String cancelText,
      required BuildContext context}) {
  Get.snackbar(
    '',
    '',

    titleText: Text(title, style: GoogleFonts.ibmPlexSansArabic(
        fontSize: 18.sp, color: AppColors.white, fontWeight: FontWeight.bold),),
    messageText: Text(bodyString, style: GoogleFonts.ibmPlexSansArabic(
        fontSize: 16.sp,
        color: AppColors.white,
        fontWeight: FontWeight.normal),),
    colorText: Colors.white,
    backgroundColor: Colors.green,
    icon: const Icon(Icons.add_alert, color: AppColors.white,),
  );
}
// massageSUCCES(
//     {required String bodyString,
//     required String okText,
//     required BuildContext context}) {
//   AwesomeDialog(
//           context: context,
//           dialogType: DialogType.success,
//           animType: AnimType.bottomSlide,
//           desc: bodyString,
//           btnOkOnPress: () {
//             hiddenKeyboard(context);
//           },
//           btnOkText: okText)
//       .show();
// }

// massageQuestion(
//     {required String bodyString,
//     required String okText,
//     required String cancelText,
//     required Function() onPressOk,
//     required Function() onPressCancel,
//     required BuildContext context}) {
//   AwesomeDialog(
//           context: context,
//           dialogType: DialogType.noHeader,
//           animType: AnimType.bottomSlide,
//           descTextStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 17.sp ,fontWeight: FontWeight.bold),
//           reverseBtnOrder: true,
//           desc: bodyString,
//           btnOkOnPress: onPressOk,
//           btnCancelOnPress: onPressCancel,
//           btnCancelText: cancelText,
//           btnOkText: okText)
//       .show();
// }
//
// massageDoneCreateOrder(
//     {required String title,
//     required String bodyString,
//     required String cancelText,
//     required Function() onPressed,
//     required BuildContext context}) {
//   AwesomeDialog(
//           context: context,
//           dialogType: DialogType.noHeader,
//           animType: AnimType.bottomSlide,
//           body: Column(
//             children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               CustomSvgImage(imageName: 'check', height: 90.h),
//               SizedBox(
//                 height: 10.h,
//               ),
//               CustomText(title, fontSize: 24.sp),
//               CustomText(
//                 bodyString,
//                 fontFamily: 'DINNEXTLTARABIC2',
//                 fontWeight: FontWeight.w500,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//             ],
//           ),
//           btnCancelColor: AppColors.primaryColor,
//           btnCancelOnPress: onPressed,
//           btnCancelText: cancelText)
//       .show();
// }

getSheetError(String title) {
  return Get.snackbar(
    '',
    '',
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CustomText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Icon(
          Icons.info,
          color: Colors.red,
        ),
      ],
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
  );
}

getSheetSucsses(String title) {
  return Get.snackbar(
    '',
    '',
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.green,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      ],
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
  );
}

/// Logging config
void printLog([dynamic rawData, DateTime? startTime, Level? level]) {
  if (foundation.kDebugMode) {
    var time = '';
    if (startTime != null) {
      final endTime = DateTime.now().difference(startTime);
      final icon = endTime.inMilliseconds > 2000
          ? '⌛️Slow-'
          : endTime.inMilliseconds > 1000
          ? '⏰Medium-'
          : '⚡️Fast-';
      time = '[$icon${endTime.inMilliseconds}ms]';
    }

    try {
      final data = '$rawData';
      final log = '$time${data.toString()}';

      /// print log for ios
      if (UniversalPlatform.isIOS) {
        debugPrint('=============================================');
        debugPrint(log);
        debugPrint('=============================================');
        return;
      }

      /// print log for android
      switch (level) {
        case Level.error:
          printError(log, StackTrace.empty);
          break;
        case Level.warning:
          logger.w(log);
          break;
        case Level.info:
          logger.i(log);
          break;
        case Level.debug:
          logger.d(log);
          break;
        case Level.verbose:
          logger.w(log);
          break;
        default:
          if (time.startsWith('[⌛️Slow-')) {
            logger.w(log);
            break;
          }
          if (time.startsWith('[⏰Medium-')) {
            logger.w(log);
            break;
          }
          try{
            logger.w(log);
          }catch(e){
            logger.w(log);

          }
          break;
      }
    } catch (err, trace) {
      printError(err, trace);
    }
  }
}
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: !UniversalPlatform.isIOS,
    printEmojis: true,
    printTime: true,
  ),
  output: CustomOutput(),
);

class CustomOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(debugPrint);
  }
}

void printError(dynamic err, [dynamic trace, dynamic message]) {
  if (!foundation.kDebugMode) {
    return;
  }

  final shouldHide = trace == null ||
      '$trace'.isEmpty ||
      '$trace'.contains('package:inspireui');
  if (shouldHide) {
    logger.d(err, error: message, stackTrace: StackTrace.empty);
    return;
  }

  logger.e(err, error: message ?? 'Stack trace:');
}


