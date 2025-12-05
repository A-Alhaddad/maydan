import 'package:maydan/widgets/my_library.dart';

import '../../../../widgets/booking_success_dialog.dart';
import '../../main_User.dart';

class ActivityDetailsPage extends StatelessWidget {
  final dynamic matchId;

  ActivityDetailsPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      init: AppGet(),
      id: 'MatchReservationPage',
      builder: (controller) {
        final match = controller.matches.firstWhere(
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
        final String matchTime = match["time"] ?? "";
        final String matchDate = match["date"] ?? "";
        final String description = match["description"] ?? "مدرب كرة قدم معتمد بخبرة تفوق 8 سنوات في تدريب اللاعبين من مختلف الأعمار والمستويات.\n\nأخصص برامج تدريبية فردية وجماعية تركّز على تطوير اللياقة البدنية، الفهم التكتيكي، والجاهزية الذهنية داخل الملعب. اشتغلت مع فرق أحياء ومراكز رياضية، وأؤمن أن كل لاعب لديه فرصة حقيقية للتطور إذا حصل على التوجيه المناسب.\n\nإذا كنت تبحث عن تدريب جاد وممتع، احجز جلستك معي وابدأ رحلتك نحو مستوى أعلى.";
        final String matchTypeKey =
            match["type"] ?? "match"; // "match" / "challenge" / "activity"
        final String imageName = match["photo"] ?? "stadiumImg";
        final Object price = match["price"] ?? 0;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Column(
                children: [
                  _buildTopCard(
                    activityName: 'اسم النشاط',
                    stadiumLocation: stadiumLoc,
                    matchTime: matchTime,
                    matchDate: '7 إلى 10 نوفمبر',
                    matchTypeKey: matchTypeKey,
                    imageName: imageName,
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SectionHeader(
                            iconName: "icon20",
                            title: "detailsActivity".tr,
                            showMore: false,
                          ),
                          SizedBox(height: 18.h),
                          typeDetails(key: 'countSubscribe' ,value: '18'),
                          typeDetails(key: 'stadium' ,value: stadiumName),
                          typeDetails(key: 'size' ,value: '36x27 م'),
                          typeDetails(key: 'services' ,value: 'كرة - زجاجة ماء'),
                          Expanded(
                            child: SingleChildScrollView(
                              child: CustomText(
                                description,
                                fontSize: 17.sp,
                                color: Colors.white,
                                textAlign: TextAlign.justify,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          _buildBottomBar(
                              price: price.toString(), matchSelect: match),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= TOP CARD ================= //

  Widget _buildTopCard({
    required String activityName,
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
                  activityName,
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
                      ),
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

  Widget typeDetails({required String key, required String value}) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          CustomText(
            key.tr,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
          SizedBox(width: 20.w,),
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

  Widget _matchChip({required String time, required String date}) {
    return Container(
      // width: double.infinity,
      width: 370.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
              SizedBox(width: 10.w),
              CustomText(
                date,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkIndigo,
              ),
            ],
          ),
          // SizedBox(
          //   width: 15.w,
          // ),
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
              SizedBox(width: 10.w),
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

  // ================= BOTTOM BAR ================= //

  Widget _buildBottomBar(
      {required String price, required Map<String, String> matchSelect}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomMainButton(
                title: "subscribe".tr,
                onTap: () async {
                  AppGet.to.bottomNavIndex=0;
                  Get.offAll(() => MainUserScreen());
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
}
