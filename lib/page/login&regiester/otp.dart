import 'package:maydan/widgets/my_library.dart';
import 'package:flutter/services.dart';

import 'ChangePassword.dart';

class OTP extends StatefulWidget {
  OTP({
    super.key,
    this.isFromSignUp = false,
    required this.phone,
    this.goToPasswordReset = false,
  });

  final bool isFromSignUp;
  final String phone;
  final bool goToPasswordReset;

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'OTP',
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80.h),
                          CustomText(
                            "otpTitle".tr,
                            fontSize: 28.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 12.h),
                          CustomText(
                            "otpSubtitle".tr,
                            fontSize: 15.sp,
                            color: Colors.white,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 30.h),
                          CustomTextField(
                            label: "",
                            hint: "enterOTP",
                            controller: otpCtrl,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            isPassword: true,
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                "didntReceive".tr,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              GestureDetector(
                                onTap: () {
                                  printLog('ReSend Code');
                                },
                                child: CustomText(
                                  "resend".tr,
                                  color: AppColors.green,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          if (controller.otpErrorMessage?.isNotEmpty == true)
                            Padding(
                              padding: EdgeInsetsDirectional.only(top: 5.h),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: CustomText(
                                    controller.otpErrorMessage!,
                                    color: Colors.red,
                                    fontSize: 13.sp,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),

                          const Spacer(),
                          CustomMainButton(
                            title: "verifyBtn",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final code = otpCtrl.text.trim();

                              final success = await controller.verifyOtpCode(
                                mobile: widget.phone,
                                code: code,
                                isFromSignUp: widget.isFromSignUp,
                                goToReset: widget.goToPasswordReset,
                              );

                              if (!success) return;

                              if (widget.goToPasswordReset) {
                                Get.to(() => ChangePassword());
                                return;
                              }

                              controller.changeBottomNavUser(
                                  indexBottomNav: 0, indexService: 0);
                              Get.offAll(() => MainUserScreen());
                            },
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
