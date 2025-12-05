import 'package:maydan/page/login&regiester/SignIn.dart';
import 'package:maydan/page/userPages/profile/text_screen.dart';
import 'package:maydan/widgets/my_library.dart';

import '../../../widgets/notification_Button.dart';

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
                  CircleAvatar(
                    radius: 35.r,
                    backgroundImage: AssetImage('assets/images/coach_1.png'
                        // controller.userModel?.image ?? "",
                        ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "عبدالله الراشد",
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
                title: "TrainingSchedule".tr,
                icon: 'profileIcon2',
                onTap: () => handleProfileClick(key: 'TrainingSchedule'),
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

  // ========= WIDGET FOR MENU ITEMS ========= //

  void handleProfileClick({required String key}) {
    String exampleDetails =
        'هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان و حجم و لون الخط حيث يتم التحكم في هذا النص وامكانية تغييرة في اي وقت عن طريق ادارة الموقع . يتم اضافة هذا النص كنص تجريبي للمعاينة فقط وهو لا يعبر عن أي موضوع محدد انما لتحديد الشكل العام للقسم او الصفحة أو الموقع. هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان و حجم و لون الخط حيث يتم التحكم في هذا النص وامكانية تغييرة في اي وقت عن طريق ادارة الموقع . يتم اضافة هذا النص كنص تجريبي للمعاينة.';
    switch (key) {
      case "OldReservations":
        // Get.to(() => const ProfilePage());
        break;
      case "TrainingSchedule":
        // Get.to(() => const ProfilePage());
        break;
      case "BankCards":
        // Get.to(() => const ProfilePage());
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
        Get.offAll(SignIn());
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
