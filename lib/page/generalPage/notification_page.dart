import 'package:maydan/widgets/my_library.dart';


class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final List<Map<String, String>> _notifications = [
    {
      "text": "ماجد انضم إلى المباراة",
      "image": "coach_6",
    },
    {
      "text": "لا تنس موعد تدريبك اليوم مع فهد القحطاني الساعة 21:30",
      "icon": "icon11",
    },
    {
      "text": "عبد الله انضم إلى المباراة",
      "image": "coach_3",
    },
    {
      "text": "زيد انضم إلى المباراة",
      "image": "coach_1",
    },
    {
      "text": "علي انضم إلى المباراة",
      "image": "coach_5",
    },
    {
      "text":
          "مباراة في ملعب السالمية يوم الأربعاء 15/10 الساعة 21:00.\nهل سيلعبون بدونك؟",
      "icon": "icon6",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'NotificationsPage',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 70.h),
                  Row(
                    children: [
                      CustomBackButton(onTap: () => Get.back(),),
                      Expanded(
                        child: Center(
                          child: CustomText(
                            "notificationsTitle".tr,
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 42.w),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final item = _notifications[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Row(
                              children: [
                                if (item["image"] != null)
                                  CircleAvatar(
                                    radius: 22.r,
                                    backgroundImage: AssetImage(
                                      "assets/images/${item["image"]}.png",
                                    ),
                                  )
                                else if (item["icon"] != null)
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CustomSvgImage(
                                        imageName: item["icon"]!,
                                        width: 22.w,
                                        height: 22.w,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 20.w,),
                                Expanded(
                                  child: CustomText(
                                    item["text"] ?? "",
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    maxLines: 3,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                        );
                      },
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
}
