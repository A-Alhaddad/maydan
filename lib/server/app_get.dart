// TODO Implement this library.
import 'dart:async';
import 'dart:ffi';
import 'package:maydan/page/userPages/main_User.dart';
import 'package:maydan/page/userPages/service/booking/stadium_booking.dart';
import '../page/generalPage/notification_page.dart';
import '../page/userPages/home/home.dart';
import '../page/userPages/profile/profile.dart';
import '../page/userPages/service/bodyService/service_main_content.dart';
import '../page/userPages/service/bodyService/service_search_coach.dart';
import '../page/userPages/service/bodyService/service_search_match.dart';
import '../page/userPages/service/service.dart';
import '../widgets/my_library.dart';

class AppGet extends GetxController {
  static AppGet get to => Get.put(AppGet());
  late Locale appLocale;
  String? otpErrorMessage;
  String isValidCode = "123456";
  int bottomNavIndex = 0;
  int selectedServiceIndex = 0;
  int selectedSportTapIndex = 0;
  int selectedMatchTypeIndex = 0;
  String urlWebApp = 'https://google.com';
  Widget? widgetHome;
  bool isHomeUserLoading = true;
  Map<String, String> selectStadium = {};

  //////////////////// init ///////////////////////////
  @override
  void onInit() {
    super.onInit();
    initLanguage();
    widgetHome = Home();
  }

  void initLanguage() {
    final langCode = AppPreferences().getLanguageCode;
    final countryCode = AppPreferences().getCountryCode;
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
  }

  //////////////////// MAPS ///////////////////////////
  final List<Map<String, String>> sportsList = [
    {"key": "homeFootball", "image": "ball1"},
    {"key": "homeBasketball", "image": "ball22"},
    {"key": "homeTennis", "image": "ball3"},
    {"key": "homeVolleyball", "image": "ball4"},
  ];

  final List<Map<String, String>> matchTypesList = [
    {"key": "serviceMatchTypeMatch", "icon": "serviceMatchType1"}, // مباراة
    {"key": "serviceMatchTypeChallenge", "icon": "serviceMatchType2"}, // تحدي
    {"key": "serviceMatchTypeActivity", "icon": "serviceMatchType3"}, // أنشطة
  ];
  var matchesFilter = [];
  final matches = [
    {
      "id": "10",
      "name": "ملاعب التحدي",
      "time": "22:30 - 21:00",
      "date": "10 / 7",
      "available": "4 أماكن متاحة",
      "location": "شارع ظهران",
      "price": "مجانا",
      "photo": "stadiumImg22",
      "type": "match",
    },
    {
      "id": "11",
      "name": "ملاعب السالمية",
      "time": "23:00 - 21:30",
      "date": "12 / 7",
      "available": "3 أماكن متاحة",
      "location": "شارع الرياض",
      "price": "10 ر.ع",
      "photo": "stadiumImg11",
      "type": "activity",
    },
    {
      "id": "12",
      "name": "ملعب الأول بارك",
      "time": "20:00 - 19:00",
      "date": "15 / 7",
      "available": "2 أماكن متاحة",
      "location": "طريق الملك فهد",
      "price": "17 ر.ع",
      "photo": "stadiumImg",
      "type": "challenge",
    },
  ];

  final leftSlots = [
    {"name": "محمد", "image": "ball22.png", "indexPlayer": "L1"},
    {"name": "عبدالله", "image": "coach_4.png", "indexPlayer": "L2"},
    {"name": null, "image": null, "indexPlayer": "L3"}, // +
  ];
  final leftSlots2 = [
    {"name": null, "image": null, "indexPlayer": "L4"}, // +
    {"name": "ماجد", "image": "coach_5.png", "indexPlayer": "L5"},
  ];
  final rightSlots = [
    {"name": null, "image": null, "indexPlayer": "R1"}, // +
    {"name": "فيصل", "image": "coach_1.png", "indexPlayer": "R2"},
    {"name": null, "image": null, "indexPlayer": "R3"}, // +
  ];
  final rightSlots2 = [
    {"name": "خليل", "image": "ball1.png", "indexPlayer": "R4"},
    {"name": "أحمد", "image": "coach_6.png", "indexPlayer": "R5"},
  ];

  final newSlots = [
    {"name": null, "image": null, "indexPlayer": ""}, // +
    {"name": null, "image": null, "indexPlayer": ""}, // +
    {"name": null, "image": null, "indexPlayer": ""}, // +
  ];

  final List<Map<String, dynamic>> coaches = [
    {
      "id": "1",
      "image": "coach_1",
      "name": "عبد الرحمن الحربي",
      "rate": "4.5",
      "type": "مدرب كرة سلة",
    },
    {
      "id": "2",
      "image": "coach_2",
      "name": "نوار السعدي",
      "rate": "4.7",
      "type": "مدرب تنس طاولة",
    },
    {
      "id": "3",
      "image": "coach_3",
      "name": "فهد القحطاني",
      "rate": "4.2",
      "type": "مدرب كرة قدم",
    }
  ];

  final stadiums = [
    {
      "id": "11",
      "name": "ملعب السالمية الشبابي",
      "location": "الرياض، شارع السالمية",
      "price": "400",
      "size": "36x27 م",
      "image": "stadiumImg",
    },
    {
      "id": "12",
      "name": "ملعب التحدي",
      "location": "الرياض، شارع التحدي",
      "price": "350",
      "size": "30x25 م",
      "image": "stadiumImg11",
    },
    {
      "id": "10",
      "name": "ملعب النخبة",
      "location": "الرياض، شارع النخبة",
      "price": "450",
      "size": "40x28 م",
      "image": "stadiumImg22",
    },
  ];

  final List<Map<String, String>> bankCards = [
    {"type": "visa", "image": "visa" , "name" : "Mashaal Al Rashid" , "number" : "3590 0899 4961 7102"},
    {"type": "master", "image": "master" , "name" : "Mashaal Al Rashid" , "number" : "3590 0899 4961 7102"},
  ];

  //////////////////// Functions ///////////////////////////

  updateScreen({required List<String> nameScreen}) {
    update(nameScreen);
  }

  Future<void> changeLanguage(String langCode, String countryCode) async {
    await AppPreferences()
        .saveLocale(countryCode: countryCode, languageCode: langCode);
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
    update();
  }

  void changeBottomNav(
      {required int indexBottomNav,
      int indexService = 0,
      int selectMatchType = -1,
      Map<String, String>? selectStadiumData}) {
    selectStadium = selectStadiumData ?? {};
    if (bottomNavIndex != indexBottomNav) {
      bottomNavIndex = indexBottomNav;
      widgetHome = _buildBodyMainUser();
      changeMatchType(selectMatchType);
    }
    if (indexBottomNav == 1) {
      selectedServiceIndex = indexService;
      serviceTitle();
      buildServiceBody();
    }
    update(['MainUserScreen', 'Home', 'Service']);
  }

  Widget _buildBodyMainUser() {
    switch (bottomNavIndex) {
      case 0:
        return Home();
      case 1:
        return Service();
      case 2:
        return Profile();
      default:
        return Home();
    }
  }

  Widget buildServiceBody() {
    switch (selectedServiceIndex) {
      // الصفحة الرئيسية في الخدمات
      case 0:
        return const ServiceMainContent();
      // ابحث عن مبارة
      case 1:
        return const ServiceSearchMatch();
      case 3:
        return const ServiceSearchCoach();
      case 4:
        return StadiumBooking(
          selected: selectStadium.isNotEmpty,
        );

      default:
        return const ServiceMainContent();
    }
  }

  String serviceTitle() {
    switch (selectedServiceIndex) {
      case 0:
        return "serviceMainTitle".tr;
      case 1:
        return "homeActionSearchMatch".tr;
      case 3:
        return "serviceBookCoachTitle".tr;
      case 4:
        return "serviceBookStadiumTitle".tr;
      case 5:
        return "serviceGridCreate2Match".tr;
      default:
        return "serviceMainTitle".tr;
    }
  }

  openNotificationsPage() {
    printLog('openNotification');
    Get.to(() => NotificationsPage());
  }

  afterLoginOrRegister(
      {bool fromLogin = false,
      bool fromRegister = false,
      bool fromChangePassword = false}) {
    isHomeUserLoading = true;
    changeBottomNav(indexBottomNav: 0 ,indexService: 0);
    Get.offAll(() => MainUserScreen());
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.delayed(
        const Duration(seconds: 2)); // مكان كول الـ API الحقيقي
    isHomeUserLoading = false;
    update(['Home']);
  }

  void changeSport(int index) {
    selectedSportTapIndex = index;
    update(['Home', 'Service']);
  }

  void changeMatchType(int index) {
    /// 0 ==> مبارة
    /// 1 ==> تحدي
    /// 2 ==> أنشطة
    if (index != selectedMatchTypeIndex && index != -1) {
      selectedMatchTypeIndex = index;
      if (selectedMatchTypeIndex == -1) {
        matchesFilter = matches;
      } else {
        filterMatchType(
            type: selectedMatchTypeIndex == 0
                ? 'match'
                : selectedMatchTypeIndex == 1
                    ? 'challenge'
                    : 'activity');
      }
    } else {
      selectedMatchTypeIndex = -1;
      matchesFilter = matches;
    }

    update(['Service']);
  }

  filterMatchType({required String type}) {
    var mFilter = [];
    for (var m in matches) {
      (m['type'] == type) ? mFilter.add(m) : null;
    }
    matchesFilter = mFilter;
  }
}
