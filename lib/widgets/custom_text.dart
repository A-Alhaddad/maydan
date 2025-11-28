import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  String? text;
  double? fontSize;
  TextAlign? textAlign;
  Color? color;
  bool? underline;
  FontWeight? fontWeight;
  int? maxLines;
  String? fontFamily;

  CustomText(this.text,
      {this.fontSize,
      this.textAlign,
      this.color,
      this.fontWeight,
      this.underline = false,
      this.maxLines,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'استبدل هذا النص',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      // style: TextStyle(
      //   fontWeight: fontWeight ?? FontWeight.w500,
      //   fontSize: fontSize ?? 18.sp,
      //   color: color ?? Colors.black,
      //   fontFamily: fontFamily ?? (fontWeight == FontWeight.bold ? 'IBM1' : 'IBM'),
      //   decoration: underline! ? TextDecoration.underline : TextDecoration.none,
      // ),
      style: GoogleFonts.ibmPlexSansArabic(
        decoration: underline! ? TextDecoration.underline : TextDecoration.none,
        fontSize: fontSize ?? 17.sp,
        color: color ?? Colors.black,
        fontWeight: fontWeight == FontWeight.bold
            ? FontWeight.bold
            : fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
