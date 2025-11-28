import 'package:maydan/splash.dart';
import 'package:maydan/widgets/my_library.dart';

import 'lang/my_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return ScreenUtilInit(
      designSize: const Size(450, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: MyTranslations(),
          builder: (context, widget) {
            final size = MediaQuery.of(context).size;
            return Stack(
              children: [
                CustomPngImage(
                  imageName: 'background',
                  width: size.width,
                  height: size.height,
                ),
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                ),
              ],
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
