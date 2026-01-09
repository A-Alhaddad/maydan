import 'package:maydan/widgets/my_library.dart';
import '../../../widgets/notification_Button.dart';
import '../../../widgets/sports_tabs.dart';


class Service extends StatelessWidget {
  Service({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'Service',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 76.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          controller.serviceTitle(),
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        NotificationButton(
                          onTap: () {
                            controller.openNotificationsPage();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    SportsTabs(
                      items: controller.sportsList,
                      selectedIndex: controller.selectedSportTapIndex,
                      isLoading: controller.isSportLoading,
                      onTap: controller.changeSport,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: controller.buildServiceBody()),
            ],
          ),
        );
      },
    );
  }


}
