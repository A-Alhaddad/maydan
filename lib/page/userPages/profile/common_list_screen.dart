import 'package:maydan/widgets/my_library.dart';

class CommonListPage extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final Widget Function(dynamic item) itemBuilder;
  final VoidCallback? onHeaderTap;

  const CommonListPage({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.001),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
            ),
            Row(
              children: [
                CustomBackButton(
                  onTap: () {
                    final canPop = Get.key.currentState?.canPop() ?? false;
                    if (canPop) {
                      Get.back();
                      return;
                    }
                    onHeaderTap?.call();
                  },
                ),
                Expanded(
                  child: Center(
                    child: CustomText(
                      title.tr,
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 42.w),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return itemBuilder(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
