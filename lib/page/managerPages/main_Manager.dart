import 'package:maydan/widgets/my_library.dart';

class MainManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'MainManagerScreen',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Expanded(
                    child: controller.widgetHome!,
                  ),
                  SizedBox(height: 8.h),
                  _buildBottomNav(controller),
                  SizedBox(height: 35.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(AppGet controller) {
    final items = [
      "icon10",
      "icon22",
      "icon23",
      "icon12",
    ];
    final itemsSelect = [
      "icon100",
      "icon26",
      "icon27",
      "icon120",
    ];
    return Container(
      width: 320.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final bool selected = controller.bottomNavIndex == index;

          return GestureDetector(
            onTap: () => controller.changeBottomNavUser(indexBottomNav: index),
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    selected ? AppColors.green : Colors.white.withOpacity(0.08),
              ),
              child: Center(
                child: CustomSvgImage(
                  imageName: selected ? '${itemsSelect[index]}' : items[index],
                  width: 26.w,
                  height: index == 2 ? 30.w : 26.w,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
