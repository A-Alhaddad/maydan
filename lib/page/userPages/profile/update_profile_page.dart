import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:maydan/widgets/my_library.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  String selectedLocale = 'ar';

  String? _localCountryId;
  String? _localCountryName;
  String? _localCityId;
  String? _localCityName;
  String _localDialCode = '+966';
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final controller = AppGet.to;
    nameCtrl = TextEditingController(text: controller.userName ?? '');
    emailCtrl = TextEditingController(text: controller.userEmail ?? '');
    _localDialCode = controller.selectedDialCode;
    _localCountryId = controller.selectedCountryId ?? controller.userCountryId;
    if (_localCountryId != null && controller.countries.isNotEmpty) {
      final match = controller.countries
          .firstWhere((c) => c['id'] == _localCountryId, orElse: () => {});
      if (match.isNotEmpty) {
        _localCountryName = match['name'];
        _localDialCode = match['dialCode'] ?? _localDialCode;
      }
    } else {
      _localCountryName = controller.selectedCountryName;
    }
    _localCityId = controller.selectedCityId ?? controller.userCityId;
    selectedLocale = controller.userLocale ?? 'ar';
    phoneCtrl = TextEditingController(
      text: _stripDialCode(controller.userMobile, _localDialCode),
    );

    // Fetch cities for current country after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_localCountryId != null && _localCountryId!.isNotEmpty) {
        await controller.fetchCitiesForCountry(_localCountryId!);
        if (_localCityId != null) {
          final match = controller.cities
              .firstWhere((c) => c['id'] == _localCityId, orElse: () => {});
          if (match.isNotEmpty) {
            setState(() {
              _localCityName = match['name'];
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: CustomText(
          "تعديل البيانات الشخصية",
          fontSize: 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetBuilder<AppGet>(
          id: 'ProfileUpdate',
          builder: (controller) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Center(child: _buildAvatar(controller)),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          label: "userName",
                          hint: "enterUserName",
                          controller: nameCtrl,
                          keyboardType: TextInputType.name,
                          suffixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          label: "البريد الإلكتروني",
                          hint: "example@email.com",
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomText(
                          "الدولة",
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        _CountrySelector(
                          selectedId: _localCountryId,
                          onChanged: (id, name, dial) async {
                            setState(() {
                              _localCountryId = id;
                              _localCountryName = name;
                              _localDialCode = dial ?? _localDialCode;
                              _localCityId = null;
                              _localCityName = null;
                            });
                            if (id != null && id.isNotEmpty) {
                              await controller.fetchCitiesForCountry(id);
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomText(
                          "المدينة",
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        _CitySelector(
                          selectedCityId: _localCityId,
                          onChanged: (id, name) {
                            setState(() {
                              _localCityId = id;
                              _localCityName = name;
                            });
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomText(
                          "الهاتف مع المقدمة",
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            SizedBox(
                              width: 110.w,
                              child: _CountryDialSelector(
                                onChanged: (id, name, dial) {
                                  setState(() {
                                    _localCountryId = id ?? _localCountryId;
                                    _localCountryName =
                                        name ?? _localCountryName;
                                    _localDialCode = dial;
                                  });
                                },
                                selectedId: _localCountryId,
                                selectedDialCode: _localDialCode,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CustomTextField(
                                label: "",
                                hint: "enterPhone",
                                controller: phoneCtrl,
                                keyboardType: TextInputType.phone,
                                suffixIcon: Icon(
                                  Icons.dialpad,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _LanguageSelector(
                          selectedLocale: selectedLocale,
                          onChanged: (val) {
                            setState(() {
                              selectedLocale = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
        child: CustomMainButton(
          title: "حفظ",
          showArrow: false,
          onTap: _saveProfile,
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final controller = AppGet.to;
    final sessionMobile = controller.userMobile ?? '';
    final formattedMobile =
        _formatMobile(phoneCtrl.text.trim(), _localDialCode);
    printLog('formattedMobile ${formattedMobile.toString()}');
    final result = await controller.updateProfileOnServer(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      mobile: formattedMobile,
      countryId: _localCountryId,
      cityId: _localCityId,
      locale: selectedLocale,
      imageFile: _pickedImage,
    );
    final ok = result['success'] == true;
    final mobileForOtp = result['mobileForOtp']?.toString();

    if (!ok) return;
    // إذا احتاج تحقق OTP نبقى في الصفحة ونظهر نافذة إدخال الرمز
    if (mobileForOtp != null && mobileForOtp.isNotEmpty) {
      _showOtpDialog(sessionMobile);
      return;
    }

    await controller.fetchUserProfile(silent: true);
    Get.back();
    Get.snackbar(
      '',
      '',
      titleText: CustomText('عملية ناجحة', color: Colors.black,fontWeight: FontWeight.bold,),
      messageText: CustomText('تم تحديث بياناتك', color: Colors.black,fontWeight: FontWeight.normal,),
      backgroundColor:AppColors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.w),
    );
  }

  String _stripDialCode(String? mobile, String dialCode) {
    if (mobile == null || mobile.isEmpty) return '';
    var cleaned = mobile.trim();
    final cleanDial = dialCode.replaceAll('+', '');
    if (cleaned.startsWith('+')) cleaned = cleaned.substring(1);
    if (cleaned.startsWith(cleanDial)) {
      return cleaned.substring(cleanDial.length);
    }
    return cleaned;
  }

  String _formatMobile(String raw, String dialCode) {
    var cleaned = raw.trim();
    if (cleaned.startsWith('0')) cleaned = cleaned.substring(1);
    final dial = dialCode.replaceAll('+', '');
    return '+$dial$cleaned';
  }

  Future<void> _showOtpDialog(String mobileForOtp) async {
    final ctxBase = Get.context ?? Get.overlayContext;
    if (ctxBase == null) return;
    final otpCtrl = TextEditingController();
    bool isVerifying = false;
    String? error;

    await showDialog(
      context: ctxBase,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> handleVerify() async {
              if (isVerifying) return;
              final code = otpCtrl.text.trim();
              if (code.isEmpty) {
                setState(() {
                  error = "أدخل الرمز";
                });
                return;
              }
              setState(() {
                isVerifying = true;
                error = null;
              });
              final ok = await AppGet.to.verifyOtpForMobileChange(
                  formattedMobile: mobileForOtp, code: code);
              if (ok) {
                Navigator.of(dialogContext).pop();
                await AppGet.to.fetchUserProfile(silent: true);
                Get.snackbar(
                  'تم',
                  'تم تأكيد رقم الهاتف',
                  backgroundColor: AppColors.green,
                  titleText: CustomText('عملية ناجحة', color: Colors.black,fontWeight: FontWeight.bold,),
                  messageText: CustomText('تم تأكيد رقم الهاتف', color: Colors.black,fontWeight: FontWeight.normal,),
                  colorText: AppColors.black,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.all(16.w),
                );
              } else {
                setState(() {
                  isVerifying = false;
                  error = AppGet.to.otpErrorMessage ?? 'رمز غير صحيح';
                });
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.darkIndigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
              title: CustomText(
                "لقد تم إرسال رمز التحقق إلى هاتفك",
                color: Colors.white,
                fontSize: 15.sp,
                textAlign: TextAlign.start,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: otpCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    enabled: !isVerifying,
                    decoration: InputDecoration(
                      hintText: "OTP",
                      counterText: '',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.green),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  if (error != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: CustomText(
                        error!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  if (isVerifying)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: CustomText(
                    "إغلاق",
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                TextButton(
                  onPressed: handleVerify,
                  child: CustomText(
                    "تأكيد",
                    color: AppColors.green,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    otpCtrl.dispose();
  }

  Widget _buildAvatar(AppGet controller) {
    final double size = 110.w;
    ImageProvider avatarProvider;
    if (_pickedImage != null) {
      avatarProvider = FileImage(_pickedImage!);
    } else if (controller.userImageUrl?.isNotEmpty == true) {
      avatarProvider = NetworkImage(controller.userImageUrl!);
    } else {
      avatarProvider = const AssetImage('assets/images/avatar.png');
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: avatarProvider,
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: _showImagePickerSheet,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showImagePickerSheet() async {
    showModalBottomSheet(
      context: Get.context ?? Get.overlayContext!,
      backgroundColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: CustomText(
                  "اختيار من المعرض",
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: CustomText(
                  "التقاط صورة",
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }
}

class _CountryDialSelector extends StatelessWidget {
  const _CountryDialSelector({
    required this.onChanged,
    this.selectedId,
    this.selectedDialCode,
  });

  final void Function(String? id, String? name, String dialCode) onChanged;
  final String? selectedId;
  final String? selectedDialCode;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ProfileUpdate',
      builder: (controller) {
        final items = controller.countries;
        String currentDial = selectedDialCode ?? controller.selectedDialCode;
        if (selectedId != null) {
          final match =
              items.firstWhere((c) => c['id'] == selectedId, orElse: () => {});
          if (match.isNotEmpty) {
            currentDial = match['dialCode'] ?? currentDial;
          }
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
          height: 54.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(26.r),
            // border: Border.all(
            //   color: Colors.white.withOpacity(0.12),
            // ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentDial,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: AppColors.darkIndigo,
              menuMaxHeight: 260.h,
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
                final country = items.firstWhere((c) => c['dialCode'] == val,
                    orElse: () => {});
                onChanged(
                  country['id'],
                  country['name'],
                  country['dialCode'] ?? val,
                );
                controller.selectCountry(country['dialCode'] ?? val,
                    country['name'] ?? controller.selectedCountryName,
                    id: country['id']);
              },
              items: items.isNotEmpty
                  ? items
                      .map(
                        (c) => DropdownMenuItem<String>(
                          value: c['dialCode'],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                c['dialCode'],
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: CustomText(
                                  c['name'],
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12.sp,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
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

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({
    required this.onChanged,
    this.selectedId,
  });

  final void Function(String id, String name, String? dialCode) onChanged;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ProfileUpdate',
      builder: (controller) {
        final items = controller.countries;
        String? currentId = selectedId ?? controller.selectedCountryId;
        final hasValue =
            currentId != null && items.any((c) => c['id'] == currentId);
        if (!hasValue) currentId = null;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(25.r),
            // border: Border.all(
            //   color: Colors.white.withOpacity(0.12),
            // ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentId?.isNotEmpty == true ? currentId : null,
              hint: CustomText(
                "اختر الدولة",
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
              dropdownColor: AppColors.darkIndigo,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: items
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c['id'],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            c['name'],
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          // SizedBox(width: 8.w),
                          // CustomText(
                          //   c['dialCode'],
                          //   color: Colors.white.withOpacity(0.6),
                          //   fontSize: 12.sp,
                          // ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                final country =
                    items.firstWhere((c) => c['id'] == val, orElse: () => {});
                currentId = val;
                onChanged(val, country['name'] ?? '', country['dialCode']);
                controller.selectCountry(
                    country['dialCode'] ?? controller.selectedDialCode,
                    country['name'] ?? controller.selectedCountryName,
                    id: country['id']);
              },
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        );
      },
    );
  }
}

class _CitySelector extends StatelessWidget {
  const _CitySelector({
    required this.onChanged,
    this.selectedCityId,
  });

  final void Function(String? id, String? name) onChanged;
  final String? selectedCityId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ProfileUpdate',
      builder: (controller) {
        final cities = controller.cities;
        final currentId = selectedCityId ?? controller.selectedCityId;
        final hasValue =
            currentId != null && cities.any((c) => c['id'] == currentId);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: hasValue ? currentId : null,
              hint: CustomText(
                cities.isEmpty ? "اختر الدولة أولاً" : "اختر المدينة",
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
              dropdownColor: AppColors.darkIndigo,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: cities
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c['id'],
                      child: CustomText(
                        c['name'],
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                final city =
                    cities.firstWhere((c) => c['id'] == val, orElse: () => {});
                onChanged(val, city['name']);
                controller.selectCity(val, city['name']);
              },
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.selectedLocale,
    required this.onChanged,
  });

  final String selectedLocale;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "اللغة",
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(25.r),
            // border: Border.all(
            //   color: Colors.white.withOpacity(0.12),
            // ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocale,
              dropdownColor: AppColors.darkIndigo,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: const [
                DropdownMenuItem(
                  value: 'ar',
                  child: CustomText(
                    'العربية',
                    color: Colors.white,
                  ),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: CustomText(
                    'English',
                    color: Colors.white,
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
