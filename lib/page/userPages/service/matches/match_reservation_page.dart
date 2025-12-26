import 'package:maydan/widgets/my_library.dart';

import '../../../../widgets/booking_success_dialog.dart';
import '../../main_User.dart';

class MatchReservationPage extends StatelessWidget {
  final dynamic matchId; // ممكن int أو String حسب بياناتك
  String index = "0";
  final bool newBooking;
  int selectPay = 0;

  MatchReservationPage(
      {super.key, required this.matchId, this.newBooking = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      init: AppGet(),
      id: 'MatchReservationPage',
      builder: (controller) {
        final match = newBooking
            ? controller.stadiums.firstWhere(
                (m) => m["id"] == matchId,
                orElse: () => {},
              )
            : controller.matches.firstWhere(
                (m) => m["id"] == matchId,
                orElse: () => {},
              );

        // شاشة ثانية في حال صار خلل في البيانات
        if (match.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            body: Center(
              child: CustomText(
                "matchReservationNotFound".tr,
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        final String stadiumName = match["name"] ?? "";
        final String stadiumLoc = match["location"] ?? "";
        final String matchTime = match["time"] ?? "20:00 - 19:00";
        final String matchDate = match["date"] ?? "15 / 7";
        final String matchTypeKey =
            match["type"] ?? "match"; // "match" / "challenge" / "activity"
        final String imageName =
            match[newBooking ? "image" : "photo"] ?? "stadiumImg";
        final Object price = match["price"] ?? 0;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Column(
                  children: [
                    _buildTopCard(
                      stadiumName: stadiumName,
                      stadiumLocation: stadiumLoc,
                      matchTime: matchTime,
                      matchDate: matchDate,
                      matchTypeKey: matchTypeKey,
                      imageName: imageName,
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          if(newBooking)
                            Column(
                              children: [
                                SectionHeader(
                                  iconName: "icon19",
                                  title: "pay?".tr,
                                  showMore: false,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          selectPay = 1;
                                          AppGet.to.updateScreen(
                                              nameScreen: ['MatchReservationPage']);
                                        },
                                        child: Container(
                                          height: 45.h,
                                          width: double.infinity,
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 20.w),
                                          decoration: BoxDecoration(
                                            color: selectPay == 1
                                                ? AppColors.green
                                                : Colors.white.withOpacity(0.06),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(40.r),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  'سأدفع حصتي'.tr,
                                                  color: selectPay == 1
                                                      ? AppColors.black
                                                      : Colors.white,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              CustomSvgImage(
                                                imageName: 'icon120',
                                                color: selectPay == 1
                                                    ? AppColors.black
                                                    : Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          selectPay = 2;
                                          AppGet.to.updateScreen(
                                              nameScreen: ['MatchReservationPage']);
                                        },
                                        child: Container(
                                          height: 45.h,
                                          width: double.infinity,
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 20.w),
                                          decoration: BoxDecoration(
                                            color: selectPay == 2
                                                ? AppColors.green
                                                : Colors.white.withOpacity(0.06),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(40.r),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  'سأدفع للجميع'.tr,
                                                  color: selectPay == 2
                                                      ? AppColors.black
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              CustomSvgImage(
                                                imageName: 'icon121',
                                                color: selectPay == 2
                                                    ? AppColors.black
                                                    : Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          SectionHeader(
                            iconName: "icon13",
                            title: "matchReservationChoosePlace".tr,
                            showMore: false,
                          ),
                          SizedBox(height: 18.h),
                          SizedBox(
                            height: 260.h,
                            width: double.infinity,
                            child: _buildPlayersGrid(),
                          ),
                          if(newBooking)
                          Column(
                            children: [
                              SizedBox(height: 25.h),
                              SectionHeader(
                                iconName: "icon15",
                                title: "aboutStadium".tr,
                                showMore: false,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              typeDetails(key: 'location', value: stadiumLoc),
                              typeDetails(key: 'fansStand', value: 'لا يوجد'),
                              typeDetails(key: 'size', value: '36x27 م'),
                              typeDetails(
                                  key: 'services', value: 'كرة - زجاجة ماء'),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // انتبه: بدون Expanded هنا
                          _buildBottomBar(
                            price: price.toString(),
                            matchSelect: match,
                          ),

                          SizedBox(height: 60.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= TOP CARD ================= //

  Widget _buildTopCard({
    required String stadiumName,
    required String stadiumLocation,
    required String matchTime,
    required String matchDate,
    required String matchTypeKey,
    required String imageName,
  }) {
    return Container(
      height: 260.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        color: Colors.white.withOpacity(0.06),
      ),
      // clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPngImage(
              imageName: imageName,
              boxFit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.65),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 55.w,
                      height: 55.w,
                      margin: EdgeInsets.only(top: 30.h),
                      padding: EdgeInsetsDirectional.only(start: 8.w),
                      decoration: BoxDecoration(
                        color: AppColors.darkIndigo,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                CustomText(
                  stadiumName,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.green,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      stadiumLocation,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.white.withOpacity(0.75),
                        AppColors.white.withOpacity(0.30),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Row(
                    children: [
                      _matchChip(
                          time: matchTime,
                          date: matchDate,
                          type: _matchTypeText(matchTypeKey)),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _matchTypeText(String typeKey) {
    switch (typeKey) {
      case "challenge":
        return "matchTypeChallenge".tr;
      case "activity":
        return "matchTypeActivity".tr;
      case "match":
      default:
        return "matchTypeMatch".tr;
    }
  }

  Widget _matchChip(
      {required String time, required String date, required String type}) {
    return Container(
      // width: double.infinity,
      width: 370.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10.w,
          ),
          Row(
            children: [
              Container(
                  width: 33.w,
                  height: 33.w,
                  padding: EdgeInsetsDirectional.all(5.h),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: CustomSvgImage(imageName: 'icon14')),
              SizedBox(width: 5.w),
              CustomText(
                type,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkIndigo,
              ),
            ],
          ),
          SizedBox(
            width: 15.w,
          ),
          Row(
            children: [
              Container(
                width: 33.w,
                height: 33.w,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 20.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4.w),
              CustomText(
                date,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkIndigo,
              ),
            ],
          ),
          SizedBox(
            width: 15.w,
          ),
          Row(
            children: [
              Container(
                width: 33.w,
                height: 33.w,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  size: 20.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4.w),
              CustomText(
                time,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkIndigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= PLAYERS AREA ================= //

  Widget _buildPlayersGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) {
                final item = newBooking
                    ? AppGet.to.newSlots[index]
                    : AppGet.to.leftSlots[index];
                return _playerSlot(
                  name: item["name"],
                  image: item["image"],
                  indexPlayer: item["indexPlayer"],
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              2,
              (index) {
                final item = newBooking
                    ? AppGet.to.newSlots[index]
                    : AppGet.to.leftSlots2[index];
                return _playerSlot(
                  name: item["name"],
                  image: item["image"],
                  indexPlayer: item["indexPlayer"],
                );
              },
            ),
          ),
        ),

        // الخط الفاصل
        Container(
          width: 1.5.w,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 360.h,
          color: AppColors.green,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              2,
              (index) {
                final item = newBooking
                    ? AppGet.to.newSlots[index]
                    : AppGet.to.rightSlots2[index];
                return _playerSlot(
                  name: item["name"],
                  image: item["image"],
                  indexPlayer: item["indexPlayer"],
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        // العمود اليمين (5 مربعات)
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) {
                final item = newBooking
                    ? AppGet.to.newSlots[index]
                    : AppGet.to.rightSlots[index];
                return _playerSlot(
                  name: item["name"],
                  image: item["image"],
                  indexPlayer: item["indexPlayer"],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _playerSlot({String? indexPlayer, String? name, String? image}) {
    final hasPlayer = name != null && image != null;

    return GestureDetector(
      onTap: () {
        if (!hasPlayer) {
          printLog('here');
          index = indexPlayer ?? '0';
          AppGet.to.update(['MatchReservationPage']);
          print(index);
        }
      },
      child: Container(
        width: 90.w,
        height: 90.w,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
                color: indexPlayer == index && !hasPlayer
                    ? AppColors.green
                    : Colors.transparent)),
        child: hasPlayer
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: AssetImage('assets/images/$image'),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    name,
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              )
            : Center(
                child: Icon(
                  Icons.add,
                  size: 50.sp,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ================= BOTTOM BAR ================= //

  Widget _buildBottomBar(
      {required String price, required Map<String, String> matchSelect}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  price,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
                if (price != 'مجانا' &&
                    price.toString().toLowerCase() != 'free')
                  SizedBox(height: 2.h),
                if (price != 'مجانا' &&
                    price.toString().toLowerCase() != 'free')
                  CustomText(
                    "matchReservationCurrency".tr,
                    fontSize: 18.sp,
                    color: AppColors.green,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomMainButton(
                title: "matchReservationCompleteBooking".tr,
                onTap: () async {
                  final match = matchSelect;
                  final String stadiumName = match["name"] ?? "";
                  final String matchTime = match["time"] ?? "20:00 - 19:00";
                  final String matchDate = match["date"] ?? "15 / 7";

                  Get.dialog(
                    BookingSuccessDialog(
                      playerName: 'عبدالله',
                      dateTimeText:
                          "${matchDate.toString()} | ${matchTime.toString()}",
                      stadiumName: stadiumName.toString(),
                      onDone: () {
                        AppGet.to.changeBottomNavUser(indexBottomNav: 0);
                        Get.offAll(() => MainUserScreen());
                      },
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }

  Widget typeDetails({required String key, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          CustomText(
            key.tr,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
          SizedBox(
            width: 20.w,
          ),
          CustomText(
            ":",
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
          const Spacer(),
          CustomText(
            value,
            color: AppColors.green,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          )
        ],
      ),
    );
  }
}
