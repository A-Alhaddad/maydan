import 'package:maydan/page/login&regiester/otp.dart';
import 'package:maydan/widgets/my_library.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final TextEditingController phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ForgetPassword',
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120.h),
                  CustomText(
                    "forgetPasswordTitle".tr,
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: "phoneNumber",
                    hint: "enterPhone",
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    suffixIcon: Icon(
                      Icons.dialpad,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  const Spacer(),
                  CustomMainButton(
                    title: "continueVerifyBtn",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(seconds: 3));
                      Get.to(()=>OTP(isFromSignUp: false,));
                    },
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
