// import 'package:maydan/pages/out_boarding/out_boarding_screen.dart';
import 'package:maydan/page/login&regiester/SignIn.dart';
import 'package:maydan/page/userPages/main_User.dart';
import 'package:maydan/widgets/my_library.dart';
import 'package:maydan/widgets/animation_manger.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppGet appGet = Get.find();
  @override
  void initState() {
    var delay = Duration(seconds: 3);
    Future.delayed(delay, () async {
      nextScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(
        child: FadeInUp(
          delay: Duration(milliseconds: 600),
          child: Center(
            child: CustomSvgImage(
              imageName: 'logoWithName',
              width: 100.w,
              height: 100.h,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> nextScreen() async {
    final bool isLoggedIn = AppPreferences().getStateLogin;
    final String token = AppPreferences().getTokenUser;

    if (isLoggedIn && token.isNotEmpty) {
      AppGet.to.apiRepository.api.setAuthToken(token);
      AppGet.to.changeBottomNavUser(indexBottomNav: 0, indexService: 0);
      await AppGet.to.fetchUserProfile(silent: true);
      await AppGet.to.loadHomeData();
      Get.offAll(() => MainUserScreen());
    } else {
      Get.off(() => SignIn());
    }
  }
}



// nextScreen({bool go_to = false, String name_Go_to = ''}) async {
//   ServerUser.serverUser.getDiscountBanner();
//   appGet.go_to = go_to;
//   appGet.go_to_name = name_Go_to;
//   if (AppPreferences().getStateLogin) {
//     AppPreferences().saveBoolValue(value: true, key: 'openBoardingScreen');
//     String token = await AppPreferences().getTokenUser;
//     var data = await AuthServer.authServer.fitchData(tokenUser: token);
//     if (data['status']) {
//       print(AppPreferences().getTokenUser);
//       appGet.loginMap.value = data['data'];
//       print('appGet.loginMap === > ${appGet.loginMap}');
//       appGet.nextLoginAndRegister(saveToken: false, getCities: true);
//     } else {
//       AppGet.to.logOut();
//       Get.off(() => HomeScreen());
//
//       AppGet.to.nextLoginAndRegister(
//           saveToken: false, getCities: true, goToHome: false);
//     }
//   } else {
//     bool openBoardingScreen =
//         await AppPreferences().getBoolValue(key: 'openBoardingScreen');
//     if (openBoardingScreen) {
//       Get.off(() => HomeScreen());
//     } else {
//       Get.off(() => OutBoardingScreen());
//       AppPreferences().saveBoolValue(value: true, key: 'openBoardingScreen');
//     }
//     AppGet.to.nextLoginAndRegister(
//         saveToken: false, getCities: true, goToHome: false);
//   }
// }

// checkNotification() async {
//   try {
//     await FirebaseMessaging.instance.getInitialMessage().then(
//       (message) {
//         if (message != null) {
//           if (message.data['go_to'] != null) {
//             nextScreen(go_to: true, name_Go_to: message.data['go_to']);
//           } else {
//             nextScreen();
//           }
//         } else {
//           nextScreen();
//         }
//       },
//     );
//   } catch (e) {
//     nextScreen();
//   }
// }
