import 'package:google_fonts/google_fonts.dart';
import 'package:maydan/widgets/my_library.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? svgIconName;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.svgIconName,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = false;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          widget.label.tr,
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 8.h),

        Focus(
          onFocusChange: (f) {
            setState(() {
              isFocused = f;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isFocused
                    ? AppColors.green
                    : Colors.white.withOpacity(0.0),
                width: 1.5,
              ),
              color: Colors.white.withOpacity(0.08),
            ),
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: obscure,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint.tr,
                hintStyle: GoogleFonts.alexandria(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14.h,
                  horizontal: 20.w,
                ),

                suffixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.w,
                ),

                // 🔥 أولوية الأيقونات:
                // 1) لو Password → عين
                // 2) لو svgIconName موجود → CustomSvgImage
                // 3) لو suffixIcon موجود → Widget عادي
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 20.w),
                    child: Icon(
                      obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                )
                    : (widget.svgIconName != null
                    ? Padding(
                  padding: EdgeInsetsDirectional.only(end: 20.w),
                  child: CustomSvgImage(
                    imageName: widget.svgIconName!,
                    width: 20.w,
                    height: 20.w,
                  ),
                )
                    : (widget.suffixIcon != null
                    ? Padding(
                  padding:
                  EdgeInsetsDirectional.only(end: 20.w),
                  child: widget.suffixIcon!,
                )
                    : null)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
