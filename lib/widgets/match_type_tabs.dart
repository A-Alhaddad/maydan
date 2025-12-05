import 'package:maydan/widgets/my_library.dart';

class MatchTypeTabs extends StatelessWidget {
  final List<Map<String, String>> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const MatchTypeTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSvgImage(
              imageName: 'serviceMatchType',
              height: 27.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: CustomText(
                "serviceSelectMatchType".tr,
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = selectedIndex == index;
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 0 : 8.w,
                ),
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.green
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          item["key"]!.tr,
                          fontSize: 18.sp,
                          color: selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        Spacer(),
                        CustomSvgImage(
                          imageName: item["icon"] ?? "",
                          width: 25.w,
                          height: 25.w,
                          color: selected
                              ? Colors.black
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
