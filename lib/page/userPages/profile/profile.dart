import 'package:maydan/page/userPages/profile/text_screen.dart';
import 'package:maydan/page/userPages/profile/update_profile_page.dart';
import 'package:maydan/widgets/my_library.dart';

import '../../../widgets/notification_Button.dart';
import 'common_list_screen.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'Profile',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // ========== HEADER ========== //
              SizedBox(
                height: 70.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _openEditProfile(),
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundImage:
                          controller.userImageUrl?.isNotEmpty == true
                              ? NetworkImage(controller.userImageUrl!)
                              : const AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () => _openEditProfile(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          controller.userName ?? "المستخدم",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16.sp,
                              color: AppColors.green,
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              "تعديل البيانات الشخصية",
                              fontSize: 13.sp,
                              color: AppColors.green,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  NotificationButton(
                    onTap: () {
                      controller.openNotificationsPage();
                    },
                  ),
                ],
              ),

              SizedBox(height: 50.w),
              // ========== MENU ITEMS ========== //
              _menuItem(
                title: "OldReservations".tr,
                icon: 'profileIcon1',
                onTap: () => handleProfileClick(key: 'OldReservations'),
              ),

              _menuItem(
                title: "serviceGridCoaches2".tr,
                icon: 'profileIcon2',
                onTap: () => handleProfileClick(key: 'serviceGridCoaches2'),
              ),

              _menuItem(
                title: "BankCards".tr,
                icon: 'profileIcon3',
                onTap: () => handleProfileClick(key: 'BankCards'),
              ),

              _menuItem(
                title: "AboutUs".tr,
                icon: 'profileIcon4',
                onTap: () => handleProfileClick(key: 'AboutUs'),
              ),

              _menuItem(
                title: "Privacy".tr,
                icon: 'profileIcon5',
                onTap: () => handleProfileClick(key: 'Privacy'),
              ),

              _menuItem(
                title: "Terms".tr,
                icon: 'profileIcon6',
                onTap: () => handleProfileClick(key: 'Terms'),
              ),

              _menuItem(
                title: "Logout".tr,
                icon: 'profileIcon7',
                onTap: () => handleProfileClick(key: 'Logout'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openEditProfile() {
    Get.to(() => UpdateProfilePage());
  }

  // ========= WIDGET FOR MENU ITEMS ========= //

  void handleProfileClick({required String key}) {
    String exampleDetails =
        'هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان و حجم و لون الخط حيث يتم التحكم في هذا النص وامكانية تغييرة في اي وقت عن طريق ادارة الموقع . يتم اضافة هذا النص كنص تجريبي للمعاينة فقط وهو لا يعبر عن أي موضوع محدد انما لتحديد الشكل العام للقسم او الصفحة أو الموقع. هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان و حجم و لون الخط حيث يتم التحكم في هذا النص وامكانية تغييرة في اي وقت عن طريق ادارة الموقع . يتم اضافة هذا النص كنص تجريبي للمعاينة.';
    switch (key) {
      case "OldReservations":
        Get.to(() => CommonListPage(
              title: "OldReservations".tr, // عنوان الشاشة
              items: AppGet.to.matchesFilter, // ليست من الكنترولر
              itemBuilder: (item) => PreviousBookingCard(
                match: item,
                typeList: "OldReservations",
              ),
            ));
        break;
      case "serviceGridCoaches2":
        Get.to(() => CommonListPage(
              title: "serviceGridCoaches2".tr, // عنوان الشاشة
              items: AppGet.to.coaches, // ليست من الكنترولر
              itemBuilder: (item) => PreviousBookingCard(
                match: item,
                typeList: "Coaches",
              ),
            ));
        break;
      case "BankCards":
        Get.to(() => CommonListPage(
              title: "BankCards".tr, // عنوان الشاشة
              items: AppGet.to.bankCards, // ليست من الكنترولر
              itemBuilder: (item) => PreviousBookingCard(
                match: item,
                typeList: "BankCards",
              ),
            ));
        break;
      case "AboutUs":
        Get.to(() => TextScreen(
              title: 'AboutUs',
              details: exampleDetails,
            ));
        break;

      case "Privacy":
        Get.to(() => TextScreen(
              title: 'Privacy',
              details: exampleDetails,
            ));
        break;

      case "Terms":
        Get.to(() => TextScreen(
              title: 'Terms',
              details: exampleDetails,
            ));
        break;

      case "Logout":
        AppGet.to.logOut();
        break;

      default:
        print("No action found for: $key");
    }
  }

  Widget _menuItem({
    required String title,
    required String icon,
    required Function() onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: CustomSvgImage(
            imageName: icon,
            width: 25.w,
            height: 25.h,
            // color: AppColors.green,
          ),
          title: CustomText(
            title,
            fontSize: 16.sp,
            color: Colors.white,
          ),
          trailing: const SizedBox(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: icon != 'profileIcon7'
              ? Divider(color: AppColors.green.withOpacity(.5), height: 10.h)
              : SizedBox(),
        )
      ],
    );
  }
}

class PreviousBookingCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final String typeList;
  const PreviousBookingCard(
      {super.key, required this.match, required this.typeList});

  @override
  Widget build(BuildContext context) {
    print(this.typeList);
    final name = match["name"] ?? "";
    final time = match["time"] ?? "";
    final date = match["date"] ?? "";
    final type = match["type"] ?? "";
    final image = match["image"] ?? "";
    final number = match["number"] ?? "";
    final price = match["price"]?.toString() ?? "";

    return typeList == 'OldReservations'
        ? Container(
            width: double.infinity,
            height: 120.h,
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
                      shape: BoxShape.circle, color: AppColors.darkIndigo),
                  child: CustomSvgImage(
                    imageName: type == 'challenge'
                        ? 'serviceMatchType2'
                        : type == 'match'
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
                        name ?? "",
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
                            date ?? "",
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
                            time ?? "",
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CustomText(
                            price ?? "",
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
          )
        : typeList == 'Coaches'
            ? Container(
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
                          shape: BoxShape.circle, color: AppColors.darkIndigo),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 5.w, end: 10.w),
                        child: CircleAvatar(
                          radius: 35.r,
                          backgroundImage: AssetImage(
                            "assets/images/${image}.png",
                          ),
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
                            name ?? "",
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
                                type,
                                fontSize: 16.sp,
                                color: AppColors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : typeList == 'BankCards'
                ? Container(
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
                                shape: BoxShape.circle, color: AppColors.white),
                            child: Center(
                                child: CustomPngImage(
                              imageName: image,
                              width: 70.w,
                            ))),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                name ?? "",
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
                                    number,
                                    fontSize: 16.sp,
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
  }
}
