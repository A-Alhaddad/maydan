import 'package:maydan/widgets/my_library.dart';

class NotificationButton extends StatelessWidget {
  final Function() onTap;

  const NotificationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55.w,
        height: 55.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
      ),
    );
  }
}
