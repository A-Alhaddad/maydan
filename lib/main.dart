import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maydan/splash.dart';
import 'package:maydan/widgets/my_library.dart';

import 'lang/my_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AppPreferences().initPreferences();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    Get.put(AppGet());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppGet>();

    return ScreenUtilInit(
      // Close to common Android portrait logical size (Pixel 9 Pro ~411dp width)
      designSize: const Size(411, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: MyTranslations(),
          builder: (context, widget) {
            final size = MediaQuery.of(context).size;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              child: Stack(
                children: [
                  CustomPngImage(
                    imageName: 'background',
                    width: size.width,
                    height: size.height,
                    boxFit: BoxFit.fill,
                  ),
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: widget!,
                  ),
                ],
              ),
            );
          },
          locale: Locale(
            AppPreferences().getLanguageCode,
            AppPreferences().getCountryCode,
          ),
          home: const Splash(),
        );
      },
    );
  }
}
