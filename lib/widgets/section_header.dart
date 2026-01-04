import 'package:maydan/widgets/my_library.dart';

class SectionHeader extends StatelessWidget {
  final String iconName;
  final String title;
  final bool showMore;
  final String? moreText;
  final VoidCallback? onMoreTap;
  final Widget? widgetInSection;

  const SectionHeader({
    super.key,
    required this.iconName,
    required this.title,
    this.showMore = false,
    this.moreText,
    this.onMoreTap,
    this.widgetInSection,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgImage(
          imageName: iconName,
          height: 27.h,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Row(
            children: [
              CustomText(
                title,
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              if (widgetInSection != null) widgetInSection! ,

            ],
          ),
        ),
        if (showMore)
          GestureDetector(
            onTap: onMoreTap,
            child: CustomText(
              moreText ?? "homeMore".tr,
              fontSize: 15.sp,
              color: AppColors.green,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
