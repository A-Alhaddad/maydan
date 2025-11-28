import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final TextAlign? textAlign;
  final Color? color;
  final bool underline;
  final FontWeight? fontWeight;
  final int? maxLines;
  final bool styleLight;

  const CustomText(
      this.text, {
        super.key,
        this.fontSize,
        this.textAlign,
        this.color,
        this.fontWeight,
        this.underline = false,
        this.maxLines,
        this.styleLight = true,
      });

  @override
  Widget build(BuildContext context) {
    final FontWeight finalWeight =
        fontWeight ??
            (styleLight ? FontWeight.w400 : FontWeight.w300);

    return Text(
      text ?? '',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.alexandria(
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontSize: fontSize ?? 15.sp,
        color: color ?? Colors.black,
        fontWeight: finalWeight,
      ),
    );
  }
}
