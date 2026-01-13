// TODO Implement this library.
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:maydan/page/login&regiester/SignIn.dart';
import 'package:maydan/page/userPages/service/booking/stadium_booking.dart';
import 'package:maydan/server/api_repository.dart';
import 'package:maydan/page/login&regiester/otp.dart';

import '../page/generalPage/notification_page.dart';
import '../page/managerPages/orders/ordersManagement.dart';
import '../page/userPages/home/home.dart';
import '../page/userPages/profile/profile.dart';
import '../page/userPages/service/bodyService/service_main_content.dart';
import '../page/userPages/service/bodyService/service_search_coach.dart';
import '../page/userPages/service/bodyService/service_search_match.dart';
import '../page/userPages/service/service.dart';
import '../widgets/my_library.dart';

class AppGet extends GetxController {
  static AppGet get to => Get.put(AppGet());

  final ApiRepository apiRepository = ApiRepository();

  late Locale appLocale;
  String? otpErrorMessage;
  bool isAuthBusy = false;
  bool isOtpChangingPhone = false;
  int bottomNavIndex = 0;
  int selectedServiceIndex = 0;
  int selectedSportTapIndex = 0;
  int selectedMatchTypeIndex = 0;
  String urlWebApp =
      dotenv.env['SERVER_URL'] ?? 'http://192.168.0.3/maydan/index.php';
  Widget? widgetHome;
  bool isHomeUserLoading = true;
  List<Map<String, dynamic>> sportsList = [];
  List<Map<String, dynamic>> matches = [];
  List<Map<String, dynamic>> _allMatches = [];
  List<Map<String, dynamic>> matchesFilter = [];
  List<Map<String, dynamic>> stadiums = [];
  List<Map<String, dynamic>> _allStadiums = [];
  List<Map<String, dynamic>> coaches = [];
  List<Map<String, dynamic>> _allCoaches = [];
  final Map<int?, List<Map<String, dynamic>>> _matchesCache = {};
  final Map<int?, List<Map<String, dynamic>>> _stadiumsCache = {};
  final Map<int?, List<Map<String, dynamic>>> _coachesCache = {};
  List<Map<String, String>> countries = [];
  List<Map<String, String>> cities = [];
  String selectedDialCode = '+966';
  String selectedCountryName = 'Saudi Arabia';
  String? selectedCountryId;
  String? selectedCityId;
  String? selectedCityName;
  String? citiesCountryId;
  int? selectedSportId;
  Map<String, dynamic> selectStadium = {};
  double? selectedStadiumHourlyPrice;
  int? bookingMatchTypeIndex;
  int? bookingDurationMinutes;
  String? bookingDateKey;
  String? bookingDayLabel;
  String? bookingTimeLabel;
  String? bookingTimeStart;
  String? bookingTimeEnd;
  double? bookingTotalPrice;
  String? bookingSportId;
  int? bookingPlayersNumber;
  int? bookingPayOption;
  int? bookingSeatIndex;
  Map<String, dynamic>? currentUser;
  String? userName;
  String? userImageUrl;
  String? userMobile;
  int? userId;
  String? userEmail;
  String? userCountryId;
  String? userCityId;
  String? userLocale;
  bool isProfileSaving = false;
  double? userLat;
  double? userLng;
  bool isSportLoading = false;
  String? bookingReservationId;

  //////////////////// init ///////////////////////////
  @override
  void onInit() {
    super.onInit();
    initLanguage();
    apiRepository.api.configureBaseHost(urlWebApp);
    final savedToken = AppPreferences().getTokenUser;
    if (savedToken.isNotEmpty) {
      apiRepository.api.setAuthToken(savedToken);
    }
    widgetHome = Home();
    _initBootstrap();
  }

  Future<void> _initBootstrap() async {
    await fetchCountries();
    if (AppPreferences().getTokenUser.isNotEmpty) {
      await fetchUserProfile(silent: true);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadHomeData();
    });
  }

  void initLanguage() {
    final langCode = AppPreferences().getLanguageCode;
    final countryCode = AppPreferences().getCountryCode;
    appLocale = Locale(langCode, countryCode);
    Get.updateLocale(appLocale);
  }

  //////////////////// MAPS ///////////////////////////
  final List<Map<String, String>> matchTypesList = [
    {"key": "serviceMatchTypeMatch", "icon": "serviceMatchType1"}, // مباراة
    {"key": "serviceMatchTypeChallenge", "icon": "serviceMatchType2"}, // تحدي
    {"key": "serviceMatchTypeActivity", "icon": "serviceMatchType3"}, // أنشطة
  ];
  final List<Map<String, dynamic>> _fallbackSports = [
    {
      "key": "homeFootball",
      "name": "Football",
      "image": "ball1",
      "imageUrl": ""
    },
    {
      "key": "homeBasketball",
      "name": "Basketball",
      "image": "ball22",
      "imageUrl": ""
    },
    {"key": "homeTennis", "name": "Tennis", "image": "ball3", "imageUrl": ""},
    {
      "key": "homeVolleyball",
      "name": "Volleyball",
      "image": "ball4",
      "imageUrl": ""
    },
  ];

  final List<Map<String, dynamic>> _fallbackMatches = [
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

  final List<Map<String, dynamic>> _fallbackCoaches = [
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

  final List<Map<String, dynamic>> _fallbackStadiums = [
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

  final List<Map<String, dynamic>> topProducts = [
    {
      "title": "شبك ملاعب كرة قدم",
      "price": 48,
      "currencyKey": "matchReservationCurrency",
      "leftImage": "ball1",
      "rightImage": "ball1",
    }
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

  List<Map<String, dynamic>> addedItemsProducts = [
    {
      "id": 1,
      "title": "شبك ملعب كرة قدم",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات …",
      "price": "48",
      "currencyKey": "matchReservationCurrency",
      "image": "ball_net",
      "showLeftPlus": false,
    },
  ];

  List<Map<String, dynamic>> addedItemsService = [
    {
      "id": 1,
      "title": "شبك ملعب كرة قدم",
      "desc": "إذا كنت تحتاج إلى عدد أكبر من الفقرات …",
      "price": "48",
      "currencyKey": "matchReservationCurrency",
      "image": "ball_net",
      "showLeftPlus": false,
    },
  ];
  final List<OrderModel> newOrders = [
    OrderModel(
      title: "proFootball".tr,
      statusKey: "orderStatusDelivered",
      statusType: OrderStatusType.green,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "football", // assets/images/football.png
      showMetaRow: false,
    ),
    OrderModel(
      title: "proFootball".tr,
      statusKey: "orderStatusDelivered",
      statusType: OrderStatusType.green,
      customer: "محمود حسن",
      ballsCount: 2,
      price: 250,
      imageName: "football",
      showMetaRow: false,
    ),
  ];

  final List<OrderModel> preOrders = [
    OrderModel(
      title: "proBasketball".tr,
      statusKey: "orderStatusShipping",
      statusType: OrderStatusType.red,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "basketball",
      showMetaRow: false,
    ),
    OrderModel(
      title: "proBasketball".tr,
      statusKey: "orderStatusShipping",
      statusType: OrderStatusType.red,
      customer: "سعيد المنسي",
      ballsCount: 10,
      price: 250,
      imageName: "basketball",
      showMetaRow: false,
    ),
  ];

  final List<OrderModel> otherOrders = [
    OrderModel(
      title: "proFootball".tr,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "football",
      showMetaRow: true,
      timeRange: "22:30 - 21:00",
      dateText: "10 / 7",
    ),
    OrderModel(
      title: "proBasketball".tr,
      customer: "سعيد المنسي",
      ballsCount: 10,
      price: 250,
      imageName: "basketball",
      showMetaRow: true,
      timeRange: "22:30 - 21:00",
      dateText: "10 / 7",
    ),
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

  void changeBottomNavUser(
      {required int indexBottomNav,
      int indexService = 0,
      int selectMatchType = -1,
      Map<String, dynamic>? selectStadiumData}) {
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

  Future<void> loginWithPhone({
    required String mobile,
    required BuildContext context,
    bool goToReset = false,
  }) async {
    if (mobile.isEmpty) {
      messageError(
          title: 'خطأ',
          bodyString: 'الرجاء إدخال رقم الجوال',
          cancelText: 'اغلاق',
          context: context);
      return;
    }

    isAuthBusy = true;
    update(['SignIn', 'OTP']);
    final res = await apiRepository.login(mobile: _formatMobile(mobile));
    isAuthBusy = false;
    update(['SignIn', 'OTP']);

    if (!res.success) {
      messageError(
        title: 'خطأ',
        bodyString: res.message ?? 'تعذر تسجيل الدخول',
        cancelText: 'اغلاق',
        context: context,
      );
      return;
    }
    printLog('${res.data}');
    Get.to(() => OTP(
          isFromSignUp: false,
          phone: mobile,
          goToPasswordReset: goToReset,
        ));
  }

  Future<void> registerWithPhone({
    required String mobile,
    required BuildContext context,
    String role = 'player',
    String name = '',
  }) async {
    if (mobile.isEmpty) {
      messageError(
          title: 'خطأ',
          bodyString: 'الرجاء إدخال رقم الجوال',
          cancelText: 'اغلاق',
          context: context);
      return;
    }

    // Resolve country id from selection (fallback to matching dial code)
    String? countryId = selectedCountryId;
    if ((countryId == null || countryId.isEmpty) &&
        selectedDialCode.isNotEmpty) {
      final match = countries.firstWhere(
          (c) => c['dialCode'] == selectedDialCode,
          orElse: () => {});
      countryId = match['id'];
    }

    isAuthBusy = true;
    update(['SignUp', 'OTP']);
    final res = await apiRepository.register(
        mobile: _formatMobile(mobile),
        role: role,
        name: name,
        countryId: countryId);
    isAuthBusy = false;
    update(['SignUp', 'OTP']);

    if (!res.success) {
      messageError(
        title: 'خطأ',
        bodyString: res.message ?? 'تعذر إنشاء الحساب',
        cancelText: 'اغلاق',
        context: context,
      );
      return;
    }
    Get.to(() => OTP(isFromSignUp: true, phone: mobile));
  }

  Future<bool> verifyOtpCode({
    required String mobile,
    required String code,
    required bool isFromSignUp,
    bool goToReset = false,
  }) async {
    otpErrorMessage = '';
    update(['OTP']);

    if (code.isEmpty) {
      otpErrorMessage = 'otpShort'.tr;
      update(['OTP']);
      return false;
    }

    isAuthBusy = true;
    update(['OTP']);
    final res =
        await apiRepository.verifyOtp(mobile: _formatMobile(mobile), otp: code);
    isAuthBusy = false;
    update(['OTP']);

    if (!res.success) {
      otpErrorMessage = res.message ?? 'otpWrong'.tr;
      update(['OTP']);
      return false;
    }

    otpErrorMessage = '';
    update(['OTP']);

    final userFromOtp = _extractUser(res.data);
    if (userFromOtp != null) {
      _setUserData(userFromOtp);
    }

    final token = _extractToken(res.data);
    if (!goToReset) {
      await _handleAuthSuccess(token: token);
    } else if (token != null && token.isNotEmpty) {
      await AppPreferences().saveStringValue(value: token, key: 'tokenUser');
      apiRepository.api.setAuthToken(token);
    }
    return true;
  }

  Future<bool> verifyOtpForMobileChange({
    required String formattedMobile,
    required String code,
  }) async {
    if (code.trim().isEmpty) {
      otpErrorMessage = 'otpShort'.tr;
      update(['ProfileUpdate']);
      return false;
    }
    isOtpChangingPhone = true;
    update(['ProfileUpdate']);
    final res =
        await apiRepository.verifyOtp(mobile: formattedMobile, otp: code);
    isOtpChangingPhone = false;
    update(['ProfileUpdate']);

    if (!res.success) {
      otpErrorMessage = res.message ?? 'otpWrong'.tr;
      update(['ProfileUpdate']);
      return false;
    }
    otpErrorMessage = '';
    update(['ProfileUpdate']);

    final token = _extractToken(res.data);
    if (token != null && token.isNotEmpty) {
      await _handleAuthSuccess(token: token);
    }
    return true;
  }

  Future<void> _handleAuthSuccess({String? token}) async {
    if (token != null && token.isNotEmpty) {
      await AppPreferences().saveStringValue(value: token, key: 'tokenUser');
      await AppPreferences().saveBoolValue(value: true, key: 'isLogin');
      apiRepository.api.setAuthToken(token);
    }
    await fetchUserProfile();
    await loadHomeData();
  }

  String? _extractToken(Map<String, dynamic>? data) {
    if (data == null) return null;
    if (data['token'] != null) return data['token'].toString();
    if (data['access_token'] != null) {
      return data['access_token'].toString();
    }
    if (data['auth_token'] != null) return data['auth_token'].toString();
    if (data['data'] is Map<String, dynamic> && data['data']['token'] != null) {
      return data['data']['token'].toString();
    }
    return null;
  }

  Map<String, dynamic>? _extractUser(Map<String, dynamic>? data) {
    if (data == null) return null;
    if (data['user'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data['user'] as Map<String, dynamic>);
    }
    if (data['data'] is Map<String, dynamic>) {
      final inner = data['data'] as Map<String, dynamic>;
      if (inner['user'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(inner['user'] as Map<String, dynamic>);
      }
      // إذا كان الرد مباشرة بيانات المستخدم داخل data
      if (inner.containsKey('name') || inner.containsKey('mobile')) {
        return inner;
      }
    }
    if (data.containsKey('name') || data.containsKey('mobile')) {
      return data;
    }
    return null;
  }

  void _setUserData(Map<String, dynamic>? user) {
    if (user == null || user.isEmpty) return;
    currentUser = user;
    userId = int.tryParse(user['id']?.toString() ?? '');
    userName = _extractUserName(user);
    userMobile = user['mobile']?.toString();
    userImageUrl = _extractUserImage(user);
    userEmail = user['email']?.toString();
    // بلد/مدينة من مفاتيح مباشرة أو كائنات متداخلة
    final countryObj = user['country'] is Map<String, dynamic>
        ? user['country'] as Map<String, dynamic>
        : null;
    final cityObj = user['city'] is Map<String, dynamic>
        ? user['city'] as Map<String, dynamic>
        : null;

    userCountryId = user['country_id']?.toString() ??
        user['countryId']?.toString() ??
        countryObj?['id']?.toString();
    userCityId = user['city_id']?.toString() ??
        user['cityId']?.toString() ??
        cityObj?['id']?.toString();

    userLocale = user['locale']?.toString();
    selectedCountryId = userCountryId ?? selectedCountryId;
    selectedCityId = userCityId ?? selectedCityId;

    // Sync selected country/dial if available
    if (userCountryId != null && userCountryId!.isNotEmpty) {
      final match = countries.firstWhere((c) => c['id'] == userCountryId,
          orElse: () => {});
      if (match.isNotEmpty) {
        selectedCountryId = match['id'];
        selectedCountryName = match['name'] ?? selectedCountryName;
        selectedDialCode = match['dialCode'] ?? selectedDialCode;
      }
    } else if (countryObj != null) {
      selectedCountryId = countryObj['id']?.toString() ?? selectedCountryId;
      selectedCountryName =
          countryObj['name']?.toString() ?? selectedCountryName;
      final dial = countryObj['phone_code']?.toString();
      if (dial != null && dial.isNotEmpty) {
        selectedDialCode = dial.startsWith('+') ? dial : '+$dial';
      }
    }
    update(['Profile', 'Home', 'ProfileUpdate']);
  }

  String? _extractUserName(Map<String, dynamic> user) {
    final raw = user['name'] ??
        user['full_name'] ??
        user['username'] ??
        user['first_name'];
    if (raw == null) return null;
    final name = raw.toString().trim();
    return name.isEmpty ? null : name;
  }

  String? _extractUserImage(Map<String, dynamic> user) {
    return user['image'];
  }

  Future<void> fetchUserProfile({bool silent = false}) async {
    final token = AppPreferences().getTokenUser;
    if (token.isEmpty) return;
    apiRepository.api.setAuthToken(token);
    final res = await apiRepository.getProfile();
    if (res.success) {
      final user = _extractUser(res.data);
      _setUserData(user);
    } else {
      if (!silent) {
        printLog('Failed to fetch profile: ${res.message}');
      }
    }
  }

  void updateUserLocally({
    String? name,
    String? mobile,
    String? imageUrl,
    String? email,
    String? countryId,
    String? countryName,
    String? cityId,
    String? cityName,
    String? locale,
    String? dialCode,
  }) {
    if (name != null && name.trim().isNotEmpty) {
      userName = name.trim();
      currentUser ??= {};
      currentUser!['name'] = userName;
    }
    if (mobile != null && mobile.trim().isNotEmpty) {
      userMobile = mobile.trim();
      currentUser ??= {};
      currentUser!['mobile'] = userMobile;
    }
    if (email != null && email.trim().isNotEmpty) {
      userEmail = email.trim();
      currentUser ??= {};
      currentUser!['email'] = userEmail;
    }
    if (countryId != null && countryId.trim().isNotEmpty) {
      userCountryId = countryId.trim();
      selectedCountryId = userCountryId;
      currentUser ??= {};
      currentUser!['country_id'] = userCountryId;
    }
    if (countryName != null && countryName.trim().isNotEmpty) {
      selectedCountryName = countryName.trim();
    }
    if (cityId != null && cityId.trim().isNotEmpty) {
      userCityId = cityId.trim();
      selectedCityId = userCityId;
      currentUser ??= {};
      currentUser!['city_id'] = userCityId;
      if (cityName != null && cityName.trim().isNotEmpty) {
        selectedCityName = cityName.trim();
      }
    }
    if (locale != null && locale.trim().isNotEmpty) {
      userLocale = locale.trim();
      currentUser ??= {};
      currentUser!['locale'] = userLocale;
    }
    if (dialCode != null && dialCode.trim().isNotEmpty) {
      selectedDialCode = dialCode.trim();
    }
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      userImageUrl = imageUrl.trim();
      currentUser ??= {};
      currentUser!['image'] = userImageUrl;
    }
    update(['Profile', 'Home', 'ProfileUpdate']);
  }

  Future<void> logOut() async {
    await AppPreferences().logOut();
    apiRepository.api.setAuthToken('');
    currentUser = null;
    userName = null;
    userMobile = null;
    userImageUrl = null;
    userEmail = null;
    userCountryId = null;
    userCityId = null;
    userLocale = null;
    selectedCountryId = null;
    selectedCityId = null;
    selectedCityName = null;
    cities = [];
    citiesCountryId = null;
    update(['Profile', 'Home']);
    Get.offAll(SignIn());
  }

  Future<Map<String, dynamic>> updateProfileOnServer({
    String? name,
    String? email,
    String? mobile,
    String? countryId,
    String? cityId,
    String? locale,
    String? avatarUrl,
    File? imageFile,
  }) async {
    final Map<String, dynamic> body = {
      '_method': 'put',
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (mobile != null && mobile.trim().isNotEmpty) 'mobile': mobile.trim(),
      if (countryId != null && countryId.trim().isNotEmpty)
        'country_id': countryId.trim(),
      if (cityId != null && cityId.trim().isNotEmpty) 'city_id': cityId.trim(),
      if (locale != null && locale.trim().isNotEmpty) 'locale': locale.trim(),
      if (avatarUrl != null && avatarUrl.trim().isNotEmpty)
        'avatar_url': avatarUrl.trim(),
    };

    bool hasImage = imageFile != null;
    dynamic payload;

    if (hasImage) {
      final fileName = imageFile!.path.split(Platform.pathSeparator).last;
      payload = dio.FormData.fromMap(body)
        ..files.add(MapEntry(
          'image',
          await dio.MultipartFile.fromFile(imageFile!.path, filename: fileName),
        ));
    } else {
      payload = body;
      if (body.isEmpty) {
        return {
          'success': true,
        };
      }
    }

    isProfileSaving = true;
    update(['ProfileUpdate']);
    final res = await apiRepository.updateProfile(payload, multipart: hasImage);
    isProfileSaving = false;
    update(['ProfileUpdate']);

    if (!res.success) {
      final ctx = Get.context ?? Get.overlayContext;
      if (ctx != null) {
        messageError(
          title: 'خطأ',
          bodyString: res.message ?? 'تعذر تحديث البيانات',
          cancelText: 'اغلاق',
          context: ctx,
        );
      } else {
        printLog('Update profile failed: ${res.message}');
      }
      return {
        'success': false,
        'message': res.message,
      };
    }

    final user = _extractUser(res.data);
    if (user != null) {
      _setUserData(user);
    }

    // التقاط رقم الهاتف للـ OTP فقط من الجذر (خارج data)
    String? mobileForOtp;
    if (res.data is Map<String, dynamic>) {
      final map = res.data as Map<String, dynamic>;
      mobileForOtp = map['mobile']?.toString();
      printLog(map.toString());
    }
    return {
      'success': true,
      'mobileForOtp': mobileForOtp,
    };
  }

  Future<void> loadHomeData({bool keepSelectedSport = false}) async {
    isHomeUserLoading = true;
    update(['Home', 'Service']);
    try {
      final sportsRes = await apiRepository.getSports();
      sportsList = sportsRes.data != null && sportsRes.data!.isNotEmpty
          ? _mapSports(sportsRes.data!)
          : _fallbackSports;

      // ضبط الرياضة الأولى كافتراض
      if (sportsList.isNotEmpty && !keepSelectedSport) {
        selectedSportTapIndex = 0;
        selectedSportId = _extractSportId(0);
      }

      // تفريغ الكاشات ثم تحميل بيانات الرياضة الحالية
      _matchesCache.clear();
      _stadiumsCache.clear();
      _coachesCache.clear();

      await _loadDataForSport(selectedSportId, showPageLoader: true);
      _applySportFilter();
      changeMatchType(selectedMatchTypeIndex);
    } finally {
      isHomeUserLoading = false;
      update(['Home', 'Service']);
    }
  }

  Future<void> changeSport(int index) async {
    selectedSportTapIndex = index;
    selectedSportId = _extractSportId(index);
    isSportLoading = true;
    update(['Home', 'Service']);
    await _loadDataForSport(selectedSportId);
    isSportLoading = false;
    update(['Home', 'Service']);
  }

  void changeMatchType(int index) {
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

    update(['Home', 'Service']);
  }

  void filterMatchType({required String type}) {
    final List<Map<String, dynamic>> mFilter = [];
    for (var m in matches) {
      (m['type'] == type) ? mFilter.add(m) : null;
    }
    matchesFilter = mFilter;
  }

  void _applySportFilter() {
    final filteredMatches = _filterMatchesBySport(_allMatches);
    final filteredStadiums = _filterStadiumsBySport(_allStadiums);
    final filteredCoaches = _filterCoachesBySport(_allCoaches);

    matches = filteredMatches;
    matchesFilter = matches;
    stadiums = filteredStadiums;
    coaches = filteredCoaches;
  }

  List<Map<String, dynamic>> _filterMatchesBySport(
      List<Map<String, dynamic>> source) {
    if (selectedSportId == null) return source;
    return source
        .where((m) =>
            m['sportId']?.toString() == selectedSportId.toString() ||
            (m['sport_ids'] is List &&
                (m['sport_ids'] as List)
                    .map((e) => '$e')
                    .contains('${selectedSportId}')))
        .toList();
  }

  List<Map<String, dynamic>> _filterStadiumsBySport(
      List<Map<String, dynamic>> source) {
    if (selectedSportId == null) return source;
    return source
        .where((s) =>
            s['sportId']?.toString() == selectedSportId.toString() ||
            (s['sportIds'] is List &&
                (s['sportIds'] as List)
                    .map((e) => '$e')
                    .contains('${selectedSportId}')))
        .toList();
  }

  List<Map<String, dynamic>> _filterCoachesBySport(
      List<Map<String, dynamic>> source) {
    if (selectedSportId == null) return source;
    return source.where((c) {
      final sid = c['sportId']?.toString();
      final list = c['sportIds'] is List
          ? (c['sportIds'] as List).map((e) => '$e').toList()
          : const <String>[];
      return sid == selectedSportId.toString() ||
          list.contains('${selectedSportId}');
    }).toList();
  }

  int? _extractSportId(int index) {
    if (index < 0 || index >= sportsList.length) return null;
    final item = sportsList[index];
    final id = item['id'] ?? item['sport_id'];
    if (id == null) return null;
    return int.tryParse(id.toString()) ?? id as int?;
  }

  Future<void> _loadDataForSport(int? sportId,
      {bool showPageLoader = false}) async {
    final cacheKey = sportId;

    // استخدم الكاش إذا كان متوفر
    if (_matchesCache.containsKey(cacheKey) &&
        _stadiumsCache.containsKey(cacheKey) &&
        _coachesCache.containsKey(cacheKey)) {
      _allMatches = _matchesCache[cacheKey] ?? [];
      _allStadiums = _stadiumsCache[cacheKey] ?? [];
      _allCoaches = _coachesCache[cacheKey] ?? [];
      _applySportFilter();
      changeMatchType(selectedMatchTypeIndex);
      update(['Home', 'Service']);
      return;
    }

    if (showPageLoader) {
      isHomeUserLoading = true;
      update(['Home']);
    }
    try {
      final matchesRes = await apiRepository.getMatches(
        countryId: selectedCountryId,
        cityId: selectedCityId,
        sportId: sportId,
        lat: userLat,
        lng: userLng,
      );
      final challengesRes = await apiRepository.getChallenges(
        countryId: selectedCountryId,
        cityId: selectedCityId,
        sportId: sportId,
        lat: userLat,
        lng: userLng,
      );
      final eventsRes = await apiRepository.getEvents(
        countryId: selectedCountryId,
        cityId: selectedCityId,
        sportId: sportId,
        lat: userLat,
        lng: userLng,
      );

      final mappedMatches = [
        ..._mapMatches(matchesRes.data, type: 'match'),
        ..._mapMatches(challengesRes.data, type: 'challenge'),
        ..._mapEvents(eventsRes.data),
      ];
      final resolvedMatches =
          mappedMatches.isNotEmpty ? mappedMatches : _fallbackMatches;

      final stadiumRes = await apiRepository.getStadiums(
        countryId: selectedCountryId,
        cityId: selectedCityId,
        sportId: sportId,
        lat: userLat,
        lng: userLng,
      );
      final resolvedStadiums =
          _withFallback(_mapStadiums(stadiumRes.data), _fallbackStadiums);

      final trainersRes = await apiRepository.getTrainers(
        countryId: selectedCountryId,
        cityId: selectedCityId,
        sportId: sportId,
        lat: userLat,
        lng: userLng,
      );
      final resolvedCoaches =
          _withFallback(_mapCoaches(trainersRes.data), _fallbackCoaches);

      // printLog(resolvedStadiums);
      _matchesCache[cacheKey] = resolvedMatches;
      _stadiumsCache[cacheKey] = resolvedStadiums;
      _coachesCache[cacheKey] = resolvedCoaches;

      _allMatches = resolvedMatches;
      _allStadiums = resolvedStadiums;
      _allCoaches = resolvedCoaches;

      _applySportFilter();
      changeMatchType(selectedMatchTypeIndex);
    } finally {
      if (showPageLoader) {
        isHomeUserLoading = false;
      }
      update(['Home', 'Service']);
    }
  }

  List<Map<String, dynamic>> _mapSports(List<dynamic> data) {
    final icons = ['ball1', 'ball22', 'ball3', 'ball4'];
    return List<Map<String, dynamic>>.generate(data.length, (index) {
      final item = data[index];
      final map = item is Map<String, dynamic> ? item : {};
      return {
        'id': map['id']?.toString() ?? map['sport_id']?.toString(),
        'key': map['name']?.toString() ?? 'Sport ${index + 1}',
        'name': map['name']?.toString() ?? 'Sport ${index + 1}',
        'image': icons[index % icons.length],
        'imageUrl': map['image']?.toString() ?? '',
      };
    });
  }

  List<Map<String, dynamic>> _mapMatches(List<dynamic>? data,
      {required String type}) {
    if (data == null) return [];
    return data
        .map<Map<String, dynamic>>((item) {
          final Map<String, dynamic> map =
              item is Map<String, dynamic> ? item : {};
          final Map<String, dynamic> sport =
              map['sport'] is Map<String, dynamic>
                  ? map['sport'] as Map<String, dynamic>
                  : <String, dynamic>{};
          final Map<String, dynamic> stadium =
              map['stadium'] is Map<String, dynamic>
                  ? map['stadium'] as Map<String, dynamic>
                  : <String, dynamic>{};
          final Map<String, dynamic> reservable =
              map['reservable'] is Map<String, dynamic>
                  ? map['reservable'] as Map<String, dynamic>
                  : <String, dynamic>{};
          final Map<String, dynamic> reservableData =
              reservable['data'] is Map<String, dynamic>
                  ? reservable['data'] as Map<String, dynamic>
                  : <String, dynamic>{};
          final List<dynamic> reservableImages =
              reservableData['images'] is List ? reservableData['images'] : [];
          final sportId = map['sport_id'] ?? map['sportId'] ?? sport['id'];
          final startAt = map['start_at']?.toString() ??
              map['startAt']?.toString() ??
              map['start']?.toString();
          final endAt =
              map['end_at']?.toString() ?? map['endAt']?.toString() ?? '';
          final availableSlots = map['available_slots'] ??
              map['available'] ??
              map['slots'] ??
              map['max_slots'];
          final city = stadium['city'] ?? reservableData['city'] ?? map['city'];
          final country =
              stadium['country'] ?? reservableData['country'] ?? map['country'];
          final stadiumName = stadium['name'] ??
              reservableData['name'] ??
              map['stadium_name'] ??
              map['stadiumName'] ??
              map['reservable_name'];
          final stadiumImage = _extractImageUrl(stadium['image']);
          final reservableImageUrl = _extractImageUrl(reservableImages);
          final stadiumImagesUrl = _extractImageUrl(stadium['images']);
          final photoUrl = stadiumImage.isNotEmpty
              ? stadiumImage
              : (reservableImageUrl.isNotEmpty
                  ? reservableImageUrl
                  : (stadiumImagesUrl.isNotEmpty
                      ? stadiumImagesUrl
                      : sport['image']?.toString() ?? ''));
          return {
            'id': map['id']?.toString() ?? '',
            'name': map['name']?.toString() ??
                map['title']?.toString() ??
                'المباراة',
            'time': _formatTimeRange(startAt, endAt),
            'date': _formatDate(startAt),
            'available':
                availableSlots != null ? '$availableSlots أماكن متاحة' : 'متاح',
            'location': _composeLocation(stadium, city: city, country: country),
            'price': map['price']?.toString() ??
                stadium['hour_price']?.toString() ??
                'مجانا',
            'photoUrl': photoUrl,
            'photo': 'stadiumImg',
            'type': type,
            'sportId': sportId,
            'sport_ids': map['sport_ids'] ?? map['sports'] ?? sport['id'],
            'stadiumName': stadiumName?.toString() ?? '',
          };
        })
        .where((m) => m['id'] != '')
        .toList();
  }

  List<Map<String, dynamic>> _mapEvents(List<dynamic>? data) {
    if (data == null) return [];
    return data
        .map<Map<String, dynamic>>((item) {
          final Map<String, dynamic> map =
              item is Map<String, dynamic> ? item : {};
          final startAt = map['start_at']?.toString();
          final endAt = map['end_at']?.toString();
          return {
            'id': map['id']?.toString() ?? '',
            'name': map['name']?.toString() ??
                map['title']?.toString() ??
                'نشاط رياضي',
            'time': _formatTimeRange(startAt, endAt),
            'date': _formatDate(startAt),
            'available':
                map['slots'] != null ? '${map['slots']} أماكن متاحة' : 'متاح',
            'location': map['location']?.toString() ??
                _composeLocation(map,
                    city: map['city'], country: map['country']),
            'price': map['price']?.toString() ?? 'مجانا',
            'photoUrl': map['image']?.toString() ?? '',
            'photo': 'stadiumImg',
            'type': 'activity',
          };
        })
        .where((m) => m['id'] != '')
        .toList();
  }

  List<Map<String, dynamic>> _mapStadiums(List<dynamic>? data) {
    if (data == null) return [];
    return data
        .map<Map<String, dynamic>>((item) {
          final Map<String, dynamic> map =
              item is Map<String, dynamic> ? item : {};
          final Map<String, dynamic> meta = map['meta'] is Map<String, dynamic>
              ? map['meta'] as Map<String, dynamic>
              : {};
          final sports = map['sports'] is List ? map['sports'] as List : [];
          final firstSport =
              sports.isNotEmpty && sports.first is Map<String, dynamic>
                  ? sports.first as Map<String, dynamic>
                  : {};
          final price = firstSport['hour_price'] ??
              map['hour_price'] ??
              map['price'] ??
              meta['hour_price'];
          final sizeVal = meta['size'] ??
              meta['area'] ??
              map['size'] ??
              map['area'] ??
              firstSport['size'] ??
              firstSport['area'] ??
              (map['meta'] is Map<String, dynamic>
                  ? ((map['meta'] as Map)['size'] ??
                      (map['meta'] as Map)['area'])
                  : null);
          return {
            'id': map['id']?.toString() ?? '',
            'name': map['name']?.toString() ?? 'الملعب',
            'location': _composeLocation(map,
                city: map['city'], country: map['country']),
            'locationData': map['location'] is Map ? map['location'] : null,
            'countryData': map['country'] is Map ? map['country'] : null,
            'description': map['description']?.toString() ??
                meta['description']?.toString() ??
                '',
            'amenities': map['amenities'] ?? const [],
            'price': price?.toString() ?? '0',
            'size': sizeVal?.toString() ?? 'غير محدد',
            'slotDurations': map['slot_durations'] ??
                map['slotDurations'] ??
                meta['slot_durations'] ??
                meta['slotDurations'] ??
                const [],
            'availability':
                map['availability'] ?? meta['availability'] ?? const [],
            'workingHours':
                map['working_hours'] ?? map['workingHours'] ?? const {},
            'closedDays': map['closed_days'] ??
                map['closedDays'] ??
                meta['closed_days'] ??
                const [],
            'images': map['images'] ?? const [],
            'sports': sports,
            'imageUrl': (() {
              final primary = _extractImageUrl(map['image']);
              return primary.isNotEmpty
                  ? primary
                  : _extractImageUrl(map['images']);
            })(),
            'image': 'stadiumImg',
            'sportIds': sports
                .map((e) =>
                    e is Map<String, dynamic> ? e['sport_id'] ?? e['id'] : e)
                .toList(),
            'sportId': firstSport['sport_id'] ?? map['sport_id'],
          };
        })
        .where((m) => m['id'] != '')
        .toList();
  }

  List<Map<String, dynamic>> _mapCoaches(List<dynamic>? data) {
    if (data == null) return [];
    final avatars = [
      'coach_1',
      'coach_2',
      'coach_3',
      'coach_4',
      'coach_5',
      'coach_6'
    ];
    return List<Map<String, dynamic>>.generate(data.length, (index) {
      final Map<String, dynamic> map = data[index] is Map<String, dynamic>
          ? data[index] as Map<String, dynamic>
          : {};
      final sports = map['sports'] is List
          ? List<dynamic>.from(map['sports'] as List)
          : (map['sport_ids'] is List
              ? List<dynamic>.from(map['sport_ids'])
              : []);
      return {
        'id': map['id']?.toString() ?? '',
        'image': avatars[index % avatars.length],
        'imageUrl': map['image']?.toString() ??
            (map['meta'] is Map<String, dynamic>
                ? (map['meta']['image']?.toString() ?? '')
                : ''),
        'name': map['name']?.toString() ?? 'مدرب',
        'rate': (map['rate'] ?? map['rating'] ?? '4.5').toString(),
        'type': map['type']?.toString() ?? 'مدرب شخصي',
        'description': map['description']?.toString() ?? '',
        'sportId': map['sport_id'] ?? map['sportId'],
        'sportIds': sports
            .map(
                (e) => e is Map<String, dynamic> ? e['id'] ?? e['sport_id'] : e)
            .toList(),
      };
    }).where((c) => c['id'] != '').toList();
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return '${parsed.day} / ${parsed.month}';
  }

  String _formatTimeRange(String? start, String? end) {
    final startTime = start != null ? DateTime.tryParse(start) : null;
    final endTime = end != null ? DateTime.tryParse(end) : null;
    if (startTime != null && endTime != null) {
      final startStr =
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      final endStr =
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
      return '$endStr - $startStr';
    }
    return start ?? '';
  }

  String _composeLocation(Map<String, dynamic> map,
      {dynamic city, dynamic country}) {
    String? address;
    dynamic cityVal = city;
    dynamic countryVal = country;

    // إذا كان الموقع كائنًا يحتوي على تفاصيل
    if (map['location'] is Map) {
      final loc = map['location'] as Map;
      address = loc['address']?.toString();
      cityVal ??= loc['city'];
      countryVal ??= loc['country'];
    }

    address ??= map['address']?.toString();
    cityVal ??= map['city'];
    countryVal ??= map['country'];

    final parts = [
      if (address != null && '$address'.isNotEmpty) '$address',
      if (cityVal != null && '$cityVal'.isNotEmpty) '$cityVal',
      if (countryVal != null && '$countryVal'.isNotEmpty) '$countryVal',
    ];
    return parts.isEmpty ? 'الموقع غير متوفر' : parts.join('، ');
  }

  List<Map<String, dynamic>> _withFallback(
      List<Map<String, dynamic>>? data, List<Map<String, dynamic>> fallback) {
    if (data != null && data.isNotEmpty) return data;
    return fallback;
  }

  String _extractImageUrl(dynamic images) {
    if (images == null) return '';
    if (images is String) return images;
    if (images is Map) {
      final url = images['url'] ?? images['path'] ?? images['image'];
      return url?.toString() ?? '';
    }
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map) {
        final url = first['url'] ?? first['path'] ?? first['image'];
        return url?.toString() ?? '';
      }
      return first.toString();
    }
    return '';
  }

  Future<void> fetchCountries() async {
    final res = await apiRepository.getCountries();
    if (res.success && res.data != null) {
      countries = _mapCountries(res.data!);
      if (countries.isNotEmpty) {
        selectedDialCode = countries.first['dialCode'] ?? selectedDialCode;
        selectedCountryName = countries.first['name'] ?? selectedCountryName;
        selectedCountryId = countries.first['id'] ?? selectedCountryId;
      }
      update(['SignIn', 'SignUp', 'ProfileUpdate']);
    }
  }

  Future<void> fetchCitiesForCountry(String countryId) async {
    if (countryId.isEmpty) return;
    if (citiesCountryId == countryId && cities.isNotEmpty) {
      update(['ProfileUpdate', 'SignUp']);
      return;
    }
    final res = await apiRepository.getCitiesByCountry(countryId);
    if (res.success && res.data != null) {
      cities = _mapCities(res.data!);
      citiesCountryId = countryId;
      // auto select user's city if it exists in the list
      if (userCityId != null) {
        final match =
            cities.firstWhere((c) => c['id'] == userCityId, orElse: () => {});
        if (match.isNotEmpty) {
          selectedCityId = match['id'];
          selectedCityName = match['name'];
        }
      }
      update(['ProfileUpdate', 'SignUp']);
    }
  }

  void selectCity(String? cityId, String? cityName) {
    selectedCityId = cityId;
    selectedCityName = cityName ?? selectedCityName;
    update(['ProfileUpdate', 'SignUp']);
  }

  void selectCountry(String dialCode, String name, {String? id}) {
    selectedDialCode = dialCode;
    selectedCountryName = name;
    if (selectedCountryId != id) {
      selectedCityId = null;
      selectedCityName = null;
      cities = [];
      citiesCountryId = null;
    }
    selectedCountryId = id ?? selectedCountryId;
    update(['SignIn', 'SignUp', 'ProfileUpdate']);
  }

  List<Map<String, String>> _mapCountries(List<dynamic> data) {
    return data
        .map<Map<String, String>>((item) {
          final map = item is Map<String, dynamic> ? item : {};
          final dialCode = map['phone_code'] ??
              map['dial_code'] ??
              map['calling_code'] ??
              map['code'];
          return {
            'id': map['id']?.toString() ?? '',
            'name': map['name']?.toString() ?? '',
            'dialCode': dialCode != null
                ? '+${dialCode.toString().replaceAll('+', '')}'
                : '',
          };
        })
        .where((c) => (c['dialCode'] ?? '').isNotEmpty)
        .toList();
  }

  List<Map<String, String>> _mapCities(List<dynamic> data) {
    return data
        .map<Map<String, String>>((item) {
          final map = item is Map<String, dynamic> ? item : {};
          return {
            'id': map['id']?.toString() ?? '',
            'name': map['name']?.toString() ?? '',
          };
        })
        .where((c) => (c['id'] ?? '').isNotEmpty)
        .toList();
  }

  String _formatMobile(String raw) {
    var cleaned = raw.trim();
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    final dial =
        selectedDialCode.isNotEmpty ? selectedDialCode.replaceAll('+', '') : '';
    return '+$dial$cleaned';
  }

  int addedItemsTabIndex = 0;
  int addedItemsCategoryIndex = 0;

  List<Map<String, dynamic>> addedItemsCategories = [
    {"key": "addedCatMaintenance", "icon": Icons.build_outlined},
    {"key": "addedCatFootball", "icon": Icons.sports_soccer},
  ];
  void changeAddedItemsTab(int i) {
    addedItemsTabIndex = i;
    update(['AddedItemsPage']);
  }

  void changeAddedItemsCategory(int i) {
    addedItemsCategoryIndex = i;
    update(['AddedItemsPage']);
  }

  void openEditProduct(dynamic id) {}
  void openProductDetails(dynamic id) {}
}
