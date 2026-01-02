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
                              await controller.loginWithPhone(
                                mobile: phoneCtrl.text.trim(),
                                context: context,
                                goToReset: true,
                              );
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
