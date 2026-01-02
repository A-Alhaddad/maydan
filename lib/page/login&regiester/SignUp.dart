import 'package:maydan/page/login&regiester/SignIn.dart';
import 'package:maydan/page/login&regiester/otp.dart';
import 'package:maydan/widgets/my_library.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'SignUp',
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120.h),
                  CustomText(
                    "signUpTitle".tr,
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: "userName",
                    hint: "enterUserName",
                    controller: nameCtrl,
                    keyboardType: TextInputType.name,
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 25.h),
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
                  SizedBox(height: 25.h),
                  CustomTextField(
                    label: "password",
                    hint: "enterPassword",
                    controller: passCtrl,
                    isPassword: true,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "haveAccount".tr,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          // controller.goToSignIn()
                          Get.off(()=>SignIn());
                        },
                        child: CustomText(
                          "signInNow".tr,

                          color: AppColors.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  CustomMainButton(
                    title: "continueVerifyBtn",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(seconds: 3));
                      Get.to(()=>OTP(isFromSignUp: true,));
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
