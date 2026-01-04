import 'package:maydan/page/login&regiester/SignUp.dart';
import 'package:maydan/widgets/my_library.dart';

import 'ForgetPassword.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController phoneCtrl = TextEditingController();

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
                          SizedBox(height: 60.h),
                          Center(
                            child: CustomPngImage(
                              imageName: 'logo',
                              width: 110.w,
                              height: 110.w,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 50.h),
                          CustomText(
                            "signInTitle".tr,
                            fontSize: 26.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 24.h),
                          CustomText(
                            "phoneNumber".tr,
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 12.h),
                          _PhoneWithDialCodeField(controller: controller, phoneCtrl: phoneCtrl),
                          SizedBox(height: 25.h),
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
                          SizedBox(height: 30.h),
                          CustomMainButton(
                            title: "signInBtn",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              await controller.loginWithPhone(
                                mobile: phoneCtrl.text.trim(),
                                context: context,
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

class _DialCodeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'SignIn',
      builder: (controller) {
        final items = controller.countries;
        final currentDial = controller.selectedDialCode;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          height: 54.h,
          constraints: BoxConstraints(minWidth: 65.w, maxWidth: 95.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentDial,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: AppColors.darkIndigo,
              menuMaxHeight: 240.h,
              borderRadius: BorderRadius.circular(12.r),
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              isExpanded: true,
              selectedItemBuilder: (context) {
                return items.map((c) {
                  final dial = c['dialCode'] ?? currentDial;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      dial,
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
              onChanged: (val) {
                if (val == null) return;
                final country = items.firstWhere(
                    (c) => c['dialCode'] == val,
                    orElse: () => <String, String>{});
                controller.selectCountry(
                    val,
                    country['name'] ?? controller.selectedCountryName,
                    id: country['id']);
              },
              items: items.isNotEmpty
                  ? items
                      .map(
                        (c) => DropdownMenuItem<String>(
                          value: c['dialCode'],
                          child: Row(
                            children: [
                              CustomText(
                                c['dialCode'],
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: CustomText(
                                  c['name'],
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12.sp,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [
                      DropdownMenuItem<String>(
                        value: currentDial,
                        child: CustomText(
                          currentDial,
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
            ),
          ),
        );
      },
    );
  }
}

class _PhoneWithDialCodeField extends StatelessWidget {
  const _PhoneWithDialCodeField(
      {super.key, required this.controller, required this.phoneCtrl});

  final AppGet controller;
  final TextEditingController phoneCtrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 90.w, child: _DialCodeSelector()),
        SizedBox(width: 8.w),
        Expanded(
          flex: 2,
          child: CustomTextField(
            label: "",
            hint: "enterPhone",
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(
              Icons.dialpad,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }
}
