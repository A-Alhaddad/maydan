import 'my_library.dart';

class AppTextField extends StatelessWidget {
  String? hintText;
  int? maxLines;
  double? borderRadius;
  Color? borderColor;
  TextInputType? keyboardType;
  TextEditingController? controllerText;

  AppTextField(
    this.hintText, {
    this.maxLines,
    this.borderRadius,
    this.borderColor,
    this.keyboardType,
    this.controllerText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      controller: controllerText,
      keyboardType: keyboardType ??TextInputType.text,
      maxLines: maxLines ?? 1,
      style: TextStyle(height: 1.h, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
          hintText: hintText ?? '',
          labelText: '',
          counterText: '',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
            borderSide: BorderSide(
              width: 1,
              color: borderColor ??Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
            borderSide: BorderSide(
              width: 1,
              color: borderColor ??Colors.white,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
            borderSide: BorderSide(
              width: 1,
              color: borderColor ??Colors.white,
            ),
          ),
          hintStyle: TextStyle(
            color: Color(0xffBCBCBC),
          ),
          filled: true,
          fillColor: Colors.white),
    );
  }
}
