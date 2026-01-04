import 'package:maydan/widgets/my_library.dart';

class MainUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'MainUserScreen',
      init: AppGet(),
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, top: 40.h),
                    child: controller.widgetHome!,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24.h,
                  child: Center(
                    child: _buildBottomNav(controller),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(AppGet controller) {
    final items = [
      "icon10",
      "icon11",
      "icon12",
    ];

    return Container(
      width: 260.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.darkIndigo.withOpacity(0.9),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                  imageName: selected ? '${items[index]}0' : items[index],
                  width: 26.w,
                  height: index == 1
                      ? 18.w
                      : index == 2
                          ? 30.w
                          : 26.w,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
