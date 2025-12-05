import 'package:maydan/widgets/my_library.dart';
import '../page/userPages/main_User.dart';

class BookingSuccessDialog extends StatelessWidget {
  final String playerName;
  final String dateTimeText; // مثال: "20 أكتوبر، AM 10:00 | PM 12:00"
  final String stadiumName;
  final VoidCallback? onDone;

  const BookingSuccessDialog({
    super.key,
    required this.playerName,
    required this.dateTimeText,
    required this.stadiumName,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 324.w, // نفس مقاس الفيجما تقريباً
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: AppColors.darkIndigo,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // علامة التعجب
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green, width: 2),
              ),
              child: Center(
                child: CustomText(
                  "!",
                  fontSize: 30.sp,
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 16.h),
            CustomText(
              "bookingSuccessTitle".tr,
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 18.h),
            Divider(color: Colors.white.withOpacity(0.25)),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSvgImage(
                  imageName: "icon6",
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.green,
                ),
                SizedBox(width: 6.w),
                CustomText(
                  playerName,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSvgImage(
                  imageName: "icon16",
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.green,
                ),
                SizedBox(width: 6.w),
                CustomText(
                  dateTimeText,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSvgImage(
                  imageName: "icon15",
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.green,
                ),
                SizedBox(width: 6.w),
                CustomText(
                  stadiumName,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Get.back();

                if (onDone != null) {
                  onDone!();
                } else {
                  // يرجع على الرئيسية
                  AppGet.to.bottomNavIndex=0;
                  Get.offAll(() => MainUserScreen());
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "bookingSuccessDoneBtn".tr,
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
