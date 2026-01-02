import 'package:maydan/widgets/my_library.dart';

import '../coaches/coach_details_page.dart';


class ServiceSearchCoach extends StatelessWidget {
  const ServiceSearchCoach({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // padding: EdgeInsets.zero,
      // shrinkWrap: true,
      children: [
        Container(
          width: double.infinity,
          height: 250.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: CustomPngImage(
            imageName: 'map2',
            boxFit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        SectionHeader(
          iconName: "icon9",
          title: "homeCoachesNearYou".tr,
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
            itemCount: AppGet.to.coaches.length,
            itemBuilder: (context, index) {
              final item = AppGet.to.coaches[index];
              final imageUrl = item['imageUrl'] ?? '';
              final ImageProvider<Object> avatar =
                  imageUrl.toString().isNotEmpty
                      ? NetworkImage(imageUrl) as ImageProvider<Object>
                      : AssetImage("assets/images/${item['image']}.png")
                          as ImageProvider<Object>;
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => CoachDetailsPage(
                      coach: item,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 100.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90.h,
                            width: 100.w,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkIndigo),
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: 5.w,end: 10.w),
                              child: CircleAvatar(
                                radius: 35.r,
                                backgroundImage: avatar,
                              ),
                            ),
                          ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              item["name"] ?? "",
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                  item["rate"],
                                  fontSize: 20.sp,
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 3.w),
                                Icon(Icons.star,
                                    color: AppColors.green, size: 20.sp),
                              ],
                            ),
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
