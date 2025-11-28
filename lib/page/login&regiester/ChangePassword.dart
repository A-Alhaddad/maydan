import 'package:maydan/widgets/my_library.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController pass1Ctrl = TextEditingController();
  final TextEditingController pass2Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ChangePassword',
      init: AppGet(),
      builder: (controller) {
        final pass1 = pass1Ctrl.text;
        final pass2 = pass2Ctrl.text;

        String? errorMessage;
        if (pass1.isNotEmpty || pass2.isNotEmpty) {
          if (pass1.length < 8 || pass2.length < 8) {
            errorMessage = "passwordTooShort".tr;
          } else if (pass1 != pass2) {
            errorMessage = "passwordNotMatch".tr;
          }
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                    "changePasswordTitle".tr,
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 40.h),

                  CustomTextField(
                    label: "password",
                    hint: "enterPassword",
                    controller: pass1Ctrl,
                    isPassword: true,
                  ),

                  SizedBox(height: 25.h),

                  CustomTextField(
                    label: "password",
                    hint: "enterPassword",
                    controller: pass2Ctrl,
                    isPassword: true,
                  ),

                  SizedBox(height: 30.h),

                  if (errorMessage != null)
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
                            errorMessage,
                            color: Colors.red,
                            fontSize: 13.sp,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  CustomMainButton(
                    title: "saveBtn",
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      final p1 = pass1Ctrl.text;
                      final p2 = pass2Ctrl.text;

                      if (p1.length < 8 || p2.length < 8 || p1 != p2) {
                        controller.update(["ChangePassword"]);
                        return;
                      }

                      await Future.delayed(const Duration(seconds: 2));
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
