import 'my_library.dart';

class AppTextFieldBig extends StatelessWidget {
  String? hintText;
  int? maxLines;
  double? borderRadius;
  double? borderRadiusContainer;
  double? paddingContainer;
  Color? borderColor;
  Color? borderColorContainer;
  TextInputType? keyboardType;

  AppTextFieldBig(
    this.hintText, {
    this.maxLines,
    this.borderRadius,
    this.borderRadiusContainer,
    this.paddingContainer,
    this.borderColor,
    this.borderColorContainer,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top:paddingContainer ?? 0),
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColorContainer ?? Colors.white,
            width: 1
          ),
          borderRadius:
              BorderRadius.all(Radius.circular(borderRadiusContainer ?? 0.r))),
      child: TextField(
        enabled: true,
        keyboardType: keyboardType ?? TextInputType.text,
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
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? Colors.white,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 0.r)),
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? Colors.white,
              ),
            ),
            hintStyle: TextStyle(
              color: Color(0xffBCBCBC),
            ),
            filled: true,
            fillColor: Colors.white),
      ),
    );
  }
}
