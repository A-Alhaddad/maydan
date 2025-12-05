import 'package:maydan/widgets/my_library.dart';

class CustomBackButton extends StatelessWidget {
  final Function() onTap;

  const CustomBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
