import 'package:maydan/widgets/my_library.dart';

class ServiceMainContent extends StatelessWidget {
  const ServiceMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {"icon": "serviceIcon1", "title": "serviceGridCreateMatch"},
      {"icon": "serviceIcon2", "title": "serviceGridBookStadium"},
      {"icon": "serviceIcon3", "title": "serviceGridMatches"},
      {"icon": "serviceIcon4", "title": "serviceGridChallenges"},
      {"icon": "serviceIcon5", "title": "serviceGridActivities"},
      {"icon": "serviceIcon6", "title": "serviceGridCoaches"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final item = services[index];

        return GestureDetector(
          onTap: () {
            printLog(index);
            if (index == 0) {
              /// إنشاء نشاط رياضي
              // AppGet.to.changeBottomNav(indexBottomNav: 1 , indexService: 1 );
            } else if (index == 1) {
              /// حجز ملعب
              AppGet.to.selectedMatchTypeIndex = 0;
              AppGet.to.changeBottomNavUser(
                  indexBottomNav: 1, indexService: 4, selectMatchType: 0);            } else if (index == 2) {
              /// المباريات
              AppGet.to.selectedMatchTypeIndex = 0;
              AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 1);
            } else if (index == 3) {
              /// التحديات
              AppGet.to.selectedMatchTypeIndex = 1;
              AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 1);
            } else if (index == 4) {
              /// الأنشطة الرياضية
              AppGet.to.selectedMatchTypeIndex = 2;
              AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 1);
            } else if (index == 5) {
              /// المدربون
              // ServiceSearchCoach
              AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 3);

            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgImage(
                  imageName: item["icon"]!,
                  width: 50.w,
                  height: 50.h,
                  color: AppColors.green,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  item["title"]!.tr,
                  fontSize: 19.sp,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
