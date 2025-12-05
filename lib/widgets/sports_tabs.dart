import 'package:maydan/widgets/my_library.dart';

class SportsTabs extends StatelessWidget {
  final List<Map<String, String>> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const SportsTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final bool selected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color:
                selected ? AppColors.green : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    item["key"]!.tr,
                    fontSize: 16.sp,
                    color: selected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 10.w),
                  CustomPngImage(
                    imageName: item["image"]!,
                    width: 35.w,
                    height: 35.w,
                    boxFit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
