// TODO Implement this library.
import 'dart:async';
import 'dart:ffi';
import 'package:maydan/page/managerPages/homeManager/homeManager.dart';
import 'package:maydan/page/managerPages/product/product.dart';
import 'package:maydan/page/userPages/service/booking/stadium_booking.dart';
import 'package:maydan/server/server_user.dart';
import '../page/generalPage/notification_page.dart';
import '../page/managerPages/main_Manager.dart';
import '../page/managerPages/orders/ordersManagement.dart';
import '../page/userPages/home/home.dart';
import '../page/userPages/profile/profile.dart';
import '../page/userPages/service/bodyService/service_main_content.dart';
import '../page/userPages/service/bodyService/service_search_coach.dart';
import '../page/userPages/service/bodyService/service_search_match.dart';
import '../page/userPages/service/service.dart';
import '../services/networkMonitor.dart';
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
  String urlWebApp = 'http://ec2-100-27-245-250.compute-1.amazonaws.com';
  Widget? widgetHome;
  bool isHomeLoading = true;
  Map<String, String> selectStadium = {};
  int typeUser = 0;
  var countries = [].obs;
  List cities = [].obs;

  // حالة الإنترنت
  RxBool availableInternet = true.obs;

  //////////////////// init ///////////////////////////
  @override
  void onInit() {
    super.onInit();
    initLanguage();
    widgetHome = Home();
    NetworkMonitor().startMonitoring();
  }

  getInitDataFromServer(){
    ServerUser.serverUser.getCountries();
  }
  void initLanguage() {
    final langCode = AppPreferences().getLanguageCode;
    final countryCode = AppPreferences().getCountryCode;
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
  }


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

  void changeBottomNavUser(
      {required int indexBottomNav,
      int indexService = 0,
      int selectMatchType = -1,
      Map<String, String>? selectStadiumData}) {
    if (typeUser == 1) {
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
    } else {
        bottomNavIndex = indexBottomNav;
        widgetHome = _buildBodyMainManager();
      update(['MainManagerScreen', 'HomeManager']);
    }
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

  Widget _buildBodyMainManager() {
    switch (bottomNavIndex) {
      case 0:
        return HomeManager();
      case 1:
        return Product();
      case 2:
        return OrdersManagement();
      case 3:
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
      bool fromChangePassword = false,
      String? userName,
      String? password}) {
    isHomeLoading = true;
    if (userName == '1') {
      typeUser = 1;
      /// مستخدم عادي
      Get.offAll(() => MainUserScreen());
    } else if (userName == '2' || userName.toString().isEmpty) {
      typeUser = 2;
      /// مستخدم خدمات ومنتجات
      Get.offAll(() => MainManagerScreen());
    } else if (userName == '3') {
      typeUser = 3;
      /// مستخدم مدير ملاعب
      Get.offAll(() => MainManagerScreen());
    }
    changeBottomNavUser(indexBottomNav: 0, indexService: 0);
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.delayed(
        const Duration(seconds: 2)); // مكان كول الـ API الحقيقي
    isHomeLoading = false;
    update(['Home', 'HomeManager']);
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


  int addedItemsTabIndex = 0;
  int addedItemsCategoryIndex = 0;

  List<Map<String, dynamic>> addedItemsCategories = [
    {"key": "addedCatMaintenance", "icon": Icons.build_outlined},
    {"key": "addedCatFootball", "icon": Icons.sports_soccer},
    {"key": "addedCatMaintenance", "icon": Icons.build_outlined},
  ];


  void changeAddedItemsTab(int i) {
    addedItemsTabIndex = i;
    update(['Product']);
  }

  void changeAddedItemsCategory(int i) {
    addedItemsCategoryIndex = i;
    update(['Product']);
  }

  void openAddCategory() {}
  void openAddProduct() {}
  void openEditProduct(dynamic id) {}
  void openProductDetails(dynamic id) {}








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
    {
      "type": "visa",
      "image": "visa",
      "name": "Mashaal Al Rashid",
      "number": "3590 0899 4961 7102"
    },
    {
      "type": "master",
      "image": "master",
      "name": "Mashaal Al Rashid",
      "number": "3590 0899 4961 7102"
    },
  ];

  final List<Map<String, dynamic>> newOrders = [
    {
      "title": "كرات قدم احترافية",
      "customer": "محمد أحمد",
      "count": 4,
      "price": 250,
      "time": "22:30 - 21:00",
      "date": "10 / 7",
      "typeIcon": "icon14",
      "statusTag": "managerDashboardLatest".tr,
      "image": "ball1",
    },
    {
      "title": "كرات قدم احترافية",
      "customer": "سعيد المنسي",
      "count": 10,
      "price": 250,
      "time": "22:30 - 21:00",
      "date": "10 / 7",
      "typeIcon": "icon14",
      "statusTag": "managerDashboardLatest".tr,
      "image": "ball22",
    },
  ];

  final List<Map<String, dynamic>> topProducts = [
    {
      "title": "شبك ملاعب كرة قدم",
      "price": 48,
      "currencyKey": "matchReservationCurrency",
      "leftImage": "ball1",
      "rightImage": "ball1",
    },
    {
      "title": "شبك ملاعب كرة قدم",
      "price": 48,
      "currencyKey": "matchReservationCurrency",
      "image": "ball1",
    },
    {
      "title": "شبك ملاعب كرة قدم",
      "price": 48,
      "currencyKey": "matchReservationCurrency",
      "image": "ball1",
    }
  ];

  List<Map<String, dynamic>> addedItemsProducts = [
    {
      "id": 1,
      "title": "شبك ملعب كرة قدم",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات …",
      "price": "48",
      "currencyKey": "matchReservationCurrency",
      "image": "ball5",
      "showLeftPlus": false,
    },
    {
      "id": 1,
      "title": "شبك ملعب كرة قدم",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات …",
      "price": "48",
      "currencyKey": "matchReservationCurrency",
      "image": "ball5",
      "showLeftPlus": false,
    },
    {
      "id": 1,
      "title": "شبك ملعب كرة قدم",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات …",
      "price": "48",
      "currencyKey": "matchReservationCurrency",
      "image": "ball5",
      "showLeftPlus": false,
    },
  ];
  List<Map<String, dynamic>> addedItemsService = [
    {
      "id": 1,
      "title": "قص العشب بطول 2M",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات ,إذا كنت تحتاج إلى عدد أكبر من الفقرات ,",
      "image": "icon1",
      "showLeftPlus": false,
      "currencyKey": "",
    },
    {
      "id": 1,
      "title": "قص العشب بطول 2M",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات ,إذا كنت تحتاج إلى عدد أكبر من الفقرات ,",
      "image": "icon1",
      "showLeftPlus": false,
      "currencyKey": "",
    }, {

      "id": 1,
      "title": "قص العشب بطول 2M",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات ,إذا كنت تحتاج إلى عدد أكبر من الفقرات ,",
      "image": "icon1",
      "showLeftPlus": false,
      "currencyKey": "",
    },
  ];


}
