import 'package:maydan/page/login&regiester/SignUp.dart';
import 'package:maydan/widgets/my_library.dart';

import 'ForgetPassword.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController phoneCtrl = TextEditingController();
  // final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'SignIn',
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120.h),
                  CustomText(
                    "signInTitle".tr,
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 50.h),
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
                  // SizedBox(height: 25.h),
                  // CustomTextField(
                  //   label: "password",
                  //   hint: "enterPassword",
                  //   controller: passCtrl,
                  //   isPassword: true,
                  // ),
                  // SizedBox(height: 12.h),
                  // GestureDetector(
                  //   onTap: () {
                  //     FocusScope.of(context).unfocus();
                  //     Get.to(() => ForgetPassword());
                  //   },
                  //   child: Align(
                  //     alignment: AlignmentDirectional.centerEnd,
                  //     child: CustomText(
                  //       "forgetPassword".tr,
                  //       color: AppColors.green,
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w600,
                  //       textAlign: TextAlign.end,
                  //     ),
                  //   ),
                  // ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "noAccount".tr,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () {
                          // FocusScope.of(context).unfocus();
                          Get.off(() => SignUp());
                        },
                        child: CustomText(
                          "createAccount".tr,
                          color: AppColors.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  CustomMainButton(
                    title: "signInBtn",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(seconds: 3));
                      controller.afterLoginOrRegister(
                          fromLogin: true,
                          // password: passCtrl.text,
                          userName: phoneCtrl.text);
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
