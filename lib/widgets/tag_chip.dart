import 'my_library.dart';

class TagChip extends StatelessWidget {
  final String text;

  const TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.70),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: CustomText(
          text,
          fontSize: 12.sp,
          color: Colors.white.withOpacity(0.95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
