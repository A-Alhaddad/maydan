import 'package:maydan/page/login&regiester/SignIn.dart';
import 'package:maydan/widgets/my_library.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  String selectedRole = 'player';

  final List<Map<String, String>> roles = const [
    {'key': 'player', 'label': 'لاعب'},
    {'key': 'trainer', 'label': 'مدرب'},
    {'key': 'owner', 'label': 'مالك ملعب'},
  ];

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
                          SizedBox(height: 20.h),
                          CustomText(
                            "phoneNumber".tr,
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 12.h),
                          _PhoneWithDialCodeField(controller: controller, phoneCtrl: phoneCtrl),
                          SizedBox(height: 25.h),
                          CustomText(
                            "اختر نوع الحساب",
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: roles
                                .map(
                                  (r) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRole = r['key']!;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: selectedRole == r['key']
                                            ? AppColors.green
                                            : Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(18.r),
                                        border: Border.all(
                                          color: selectedRole == r['key']
                                              ? AppColors.green
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: selectedRole == r['key']
                                                ? Colors.black
                                                : Colors.white,
                                            size: 18.sp,
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            r['label'],
                                            fontSize: 14.sp,
                                            color: selectedRole == r['key']
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const Spacer(),
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
                          SizedBox(height: 30.h),
                          CustomMainButton(
                            title: "continueVerifyBtn",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              await controller.registerWithPhone(
                                mobile: phoneCtrl.text.trim(),
                                context: context,
                                role: selectedRole,
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
      id: 'SignUp',
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
                    orElse: () => {});
                controller.selectCountry(
                    val, country['name'] ?? controller.selectedCountryName);
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
