import 'package:maydan/page/userPages/service/activity/activity_details_page.dart';
import 'package:maydan/widgets/my_library.dart';

import '../../../../widgets/match_type_tabs.dart';
import '../matches/match_reservation_page.dart';

class ServiceSearchMatch extends StatelessWidget {
  const ServiceSearchMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // padding: EdgeInsets.zero,
      // shrinkWrap: true,
      children: [
        MatchTypeTabs(
          items: AppGet.to.matchTypesList,
          selectedIndex: AppGet.to.selectedMatchTypeIndex,
          onTap: AppGet.to.changeMatchType,
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          height: 250.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: CustomPngImage(
            imageName: 'map',
            boxFit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        SectionHeader(
          iconName: "icon5",
          title: "homeReservedMatches".tr,
          showMore: false,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: double.infinity,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            itemCount: AppGet.to.matchesFilter.length,
            itemBuilder: (context, index) {
              final item = AppGet.to.matchesFilter[index];
              return GestureDetector(
                onTap: () {
                  item['type'] == 'challenge' || item['type'] == 'match' ?
                  Get.to(
                    () => MatchReservationPage(
                      matchId: item["id"],
                    ),
                  ) : Get.to(
                        () => ActivityDetailsPage(
                      matchId: item["id"],
                    ),
                  );
                  printLog(item["id"]);
                },
                child: Container(
                  width: double.infinity,
                  height: 140.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90.h,
                        width: 100.w,
                        padding: EdgeInsets.all(22.h),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.darkIndigo),
                        child: CustomSvgImage(
                          imageName: item['type'] == 'challenge'
                              ? 'serviceMatchType2'
                              : item['type'] == 'match'
                                  ? 'serviceMatchType1'
                                  : 'serviceMatchType3',
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              item["name"] ?? "",
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    size: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  item["date"] ?? "",
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 14.w),
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.access_time,
                                    size: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  item["time"] ?? "",
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomSvgImage(
                                            imageName: 'icon6',
                                            color: AppColors.green,
                                            height: 15.h,
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            item["available"] ?? "",
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 18.sp,
                                            color: AppColors.green,
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            item["location"] ?? "",
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomText(
                                  item["price"] ?? "",
                                  fontSize: 20.sp,
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15.h,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
