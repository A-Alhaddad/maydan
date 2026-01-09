import 'package:maydan/widgets/my_library.dart';

import '../../../../widgets/match_type_tabs.dart';
import '../matches/match_reservation_page.dart';

class StadiumBooking extends StatelessWidget {
  final bool selected;

  StadiumBooking({super.key, this.selected = false});

  List<Map<String, String>> daysList = [
    {"top": "SUN", "mid": "12", "bottom": "OCT"},
    {"top": "MON", "mid": "13", "bottom": "OCT"},
    {"top": "TUE", "mid": "14", "bottom": "OCT"},
    {"top": "THU", "mid": "15", "bottom": "OCT"},
    {"top": "THU", "mid": "16", "bottom": "OCT"},
    {"top": "THU", "mid": "17", "bottom": "OCT"},
    {"top": "THU", "mid": "18", "bottom": "OCT"},
    {"top": "THU", "mid": "19", "bottom": "OCT"},
  ];

  List<String> timeSlots = [
    "16:00",
    "15:00",
    "14:00",
    "12:00",
    "20:00",
    "19:00",
    "18:00",
    "17:00",
    "24:00",
    "23:00",
    "22:00",
    "21:00",
  ];

  int selectedDayIndex = -1;
  Set<int> selectedTimeIndices = {};
  // Map<String, dynamic> selectStadium = {};

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'StadiumBooking',
      builder: (controller) {
        final app = AppGet.to;
        final List<Map<String, dynamic>> stadiumItems =
            app.stadiums.isNotEmpty ? app.stadiums : const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MatchTypeTabs(
              items: controller.matchTypesList,
              selectedIndex: controller.selectedMatchTypeIndex,
              onTap: controller.changeMatchType,
            ),
            SizedBox(height: 20.h),
            SectionHeader(
              iconName: "icon17",
              title: 'selectDay'.tr,
              showMore: false,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 95.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: daysList.length,
                separatorBuilder: (_, __) => SizedBox(width: 20.w),
                itemBuilder: (context, index) {
                  final item = daysList[index];
                  final selected = selectedDayIndex == index;

                  return GestureDetector(
                    onTap: () {
                      selectedDayIndex = index;
                      controller.updateScreen(nameScreen: ['StadiumBooking']);
                    },
                    child: Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.12),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                        border: Border.all(
                          color:
                              selected ? AppColors.green : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            item["top"] ?? "",
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          CustomText(
                            item["mid"] ?? "",
                            fontSize: 32.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          CustomText(
                            item["bottom"] ?? "",
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            SectionHeader(
              iconName: "icon18",
              title: 'selectTimeStartEnd'.tr,
              showMore: false,
            ),
            SizedBox(height: 10.h),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final selected = selectedTimeIndices.contains(index);
                return _TimeChip(
                    label: timeSlots[index],
                    selected: selected,
                    onTap: () {
                      if (selectedTimeIndices.contains(index)) {
                        selectedTimeIndices.remove(index);
                      } else {
                        selectedTimeIndices.add(index);
                      }
                      controller.updateScreen(nameScreen: ['StadiumBooking']);
                    });
              },
            ),
            SizedBox(height: 20.h),
            if (controller.selectStadium.isEmpty)
              Container(
                width: double.infinity,
                height: 250.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.r))),
                child: CustomPngImage(
                  imageName: 'map3',
                  boxFit: BoxFit.fill,
                ),
              ),
            if (controller.selectStadium.isEmpty)
              SizedBox(
                height: 25.h,
              ),
            if (controller.selectStadium.isEmpty)
              SectionHeader(
                iconName: "icon15",
                title: "availableStadiums".tr,
                showMore: false,
              ),
            if (controller.selectStadium.isEmpty)
              SizedBox(
                height: 10.h,
              ),
            SizedBox(
              width: double.infinity,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                itemCount: selected ? 1 : stadiumItems.length,
                itemBuilder: (context, index) {
                  final item =
                      selected ? AppGet.to.selectStadium : stadiumItems[index];
                  final imageUrl = item['imageUrl'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      if (!selected) {
                        controller.selectStadium = item;
                        controller.updateScreen(nameScreen: ['StadiumBooking']);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 140.h,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(26.r),
                          border: Border.all(
                              color: selected
                                  ? (AppGet.to.selectStadium['id']
                                              ?.toString() ==
                                          item['id']?.toString()
                                      ? AppColors.green
                                      : Colors.transparent)
                                  : (selectStadium['id']?.toString() ==
                                          item['id']?.toString()
                                      ? AppColors.green
                                      : Colors.transparent))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 110.h,
                            width: 120.w,
                            child: imageUrl.toString().isNotEmpty
                                ? CustomPngImageNetwork(
                                    imageUrl: imageUrl,
                                    boxFit: BoxFit.cover,
                                  )
                                : CustomPngImage(
                                    imageName: item['image'],
                                    boxFit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  item["name"] ?? "",
                                  maxLines: 1,
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 18.sp,
                                                color: AppColors.green,
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                // 'item["location"]' ?? "",
                                                'شارع المدينة',
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomSvgImage(
                                                imageName: 'icon7',
                                                color: AppColors.green,
                                                height: 15.h,
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                item["size"] ?? "",
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CustomText(
                                          item["price"] ?? "",
                                          fontSize: 20.sp,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        CustomText(
                                          "matchReservationCurrency".tr,
                                          fontSize: 16.sp,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 15.h,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomMainButton(
              title: "homeActionBook",
              onTap: () async {
                Get.to(
                  () => MatchReservationPage(
                    matchId: selected
                        ? (AppGet.to.selectStadium['id'] ?? selectStadium['id'])
                        : selectStadium['id'],
                    newBooking: true,
                  ),
                );
              },
            ),
            SizedBox(height: 120.h)
          ],
        );
      },
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: CustomText(
            label,
            fontSize: 17.sp,
            color: Colors.white,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
