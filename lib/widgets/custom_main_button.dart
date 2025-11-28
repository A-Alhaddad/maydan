import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maydan/widgets/my_library.dart';

class CustomMainButton extends StatefulWidget {
  final String title; // مفتاح الترجمة
  final Future<void> Function()? onTap;
  final double? height;
  final double? radius;
  final bool showArrow;
  final Color? color;
  final Color? textColor;

  const CustomMainButton({
    super.key,
    required this.title,
    this.onTap,
    this.height,
    this.radius,
    this.showArrow = true,
    this.color,
    this.textColor,
  });

  @override
  State<CustomMainButton> createState() => _CustomMainButtonState();
}

class _CustomMainButtonState extends State<CustomMainButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (widget.onTap == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onTap!();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.green;
    final textColor = widget.textColor ?? Colors.black;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: widget.height ?? 55.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.radius ?? 30.r),
        ),
        child: Center(
          child: _isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: textColor,
                  size: 24.w,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomText(
                          widget.title.tr,
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,

                        ),
                      ),
                      if (widget.showArrow)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: textColor,
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
