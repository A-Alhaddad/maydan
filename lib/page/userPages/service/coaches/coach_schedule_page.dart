import 'package:maydan/widgets/my_library.dart';

class CoachSchedulePage extends StatefulWidget {
  final Map<String, dynamic> coach;

  const CoachSchedulePage({
    super.key,
    required this.coach,
  });

  @override
  State<CoachSchedulePage> createState() => _CoachSchedulePageState();
}

class _CoachSchedulePageState extends State<CoachSchedulePage> {
  int selectedPackageIndex = 0;

  final List<Map<String, dynamic>> _packages = [
    {
      "price": "1200",
      "label": "الاثنين / الأربعاء / الجمعة",
    },
    {
      "price": "1000",
      "label": "الثلاثاء / الخميس / السبت",
    },
  ];

  final List<List<_DaySlotsModel>> _daysByPackage = [
    [
      _DaySlotsModel(
        dayTitle: "الاثنين",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 2,
      ),
      _DaySlotsModel(
        dayTitle: "الأربعاء",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 1,
      ),
      _DaySlotsModel(
        dayTitle: "الجمعة",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 2,
      ),
    ],
    [
      _DaySlotsModel(
        dayTitle: "الثلاثاء",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 2,
      ),
      _DaySlotsModel(
        dayTitle: "الخميس",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 1,
      ),
      _DaySlotsModel(
        dayTitle: "السبت",
        slots: [
          "15:30 - 14:00",
          "17:30 - 16:00",
          "19:30 - 18:00",
          "21:30 - 20:00"
        ],
        initiallySelected: 2,
      ),
    ],
  ];

  final Map<String, int> _selectedSlots = {};

  @override
  void initState() {
    super.initState();
    _initSelectedSlotsForCurrentPackage();
  }

  void _initSelectedSlotsForCurrentPackage() {
    _selectedSlots.clear();
    final days = _daysByPackage[selectedPackageIndex];
    for (final d in days) {
      _selectedSlots[d.dayTitle] = d.initiallySelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final coachName = widget.coach["name"] ?? "";
    final coachRating = widget.coach["rate"]?.toString() ?? "";
    final coachImage = widget.coach["image"] ?? "coach_1";
    final coachImageUrl = widget.coach["imageUrl"] ?? "";
    final ImageProvider<Object> avatar =
        coachImageUrl.toString().isNotEmpty
            ? NetworkImage(coachImageUrl) as ImageProvider<Object>
            : AssetImage("assets/images/$coachImage.png")
                as ImageProvider<Object>;
    final String price = _packages[selectedPackageIndex]["price"];
    final currentDays = _daysByPackage[selectedPackageIndex];

    return GetBuilder<AppGet>(
      id: 'CoachSchedulePage',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 70.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomBackButton(onTap: () => Get.back()),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CircleAvatar(
                      radius: 45.r,
                      backgroundImage: avatar,
                    ),
                    SizedBox(height: 14.h),
                    CustomText(
                      coachName,
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          coachRating,
                          fontSize: 14.sp,
                          color: AppColors.green,
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.star,
                          color: AppColors.green,
                          size: 18.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    SectionHeader(
                      iconName: "icon17",
                      title: "chooseDaysPackage".tr,
                      showMore: false,
                    ),
                    SizedBox(height: 10.h),
                    Column(
                      children: List.generate(_packages.length, (index) {
                        final item = _packages[index];
                        final selected = selectedPackageIndex == index;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: _DayPackageChip(
                            price: item["price"],
                            label: item["label"],
                            selected: selected,
                            onTap: () {
                              setState(() {
                                selectedPackageIndex = index;
                                _initSelectedSlotsForCurrentPackage();
                              });
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 18.h),
                    Column(
                      children: List.generate(currentDays.length, (i) {
                        final d = currentDays[i];
                        final selectedIndex = _selectedSlots[d.dayTitle] ?? -1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: DayTimeSelector(
                            header: "chooseTrainingHoursFor".tr,
                            dayTitle: d.dayTitle,
                            slots: d.slots,
                            selectedIndex: selectedIndex,
                            onSlotSelected: (slotIndex) {
                              setState(() {
                                _selectedSlots[d.dayTitle] = slotIndex;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              price,
                              fontSize: 25.sp,
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              "matchReservationCurrency".tr,
                              fontSize: 15.sp,
                              color: AppColors.green,
                            ),
                          ],
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: CustomMainButton(
                            title: "coachScheduleCompleteBooking",
                            showArrow: true,
                            onTap: () async {
                              AppGet.to.bottomNavIndex=0;
                              Get.offAll(() => MainUserScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DaySlotsModel {
  final String dayTitle;
  final List<String> slots;
  final int initiallySelected;

  _DaySlotsModel({
    required this.dayTitle,
    required this.slots,
    this.initiallySelected = -1,
  });
}

class _DayPackageChip extends StatelessWidget {
  final String price;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayPackageChip({
    super.key,
    required this.price,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(selected ? 0.08 : 0.06),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: selected ? AppColors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.w),
            Icon(
              Icons.calendar_month,
              size: 18.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomText(
                label,
                fontSize: 14.sp,
                color: Colors.white,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 60.w,
              height: 40.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    price,
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    "matchReservationCurrency".tr,
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}

class DayTimeSelector extends StatelessWidget {
  final String header;
  final String dayTitle;
  final List<String> slots;
  final int selectedIndex;
  final ValueChanged<int> onSlotSelected;

  const DayTimeSelector({
    super.key,
    required this.header,
    required this.dayTitle,
    required this.slots,
    required this.selectedIndex,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          CustomSvgImage(
            imageName: "icon18",
            height: 27.h,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Row(
              children: [
                CustomText(
                  header,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  dayTitle,
                  fontSize: 16.sp,
                  color: AppColors.green,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ]),
        GridView.builder(
          padding: EdgeInsets.only(top: 15.h , bottom: 20.h),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 3.5,
          ),
          itemBuilder: (context, index) {
            final selected = selectedIndex == index;
            return TimeSlotChip(
              label: slots[index],
              selected: selected,
              onTap: () => onSlotSelected(index),
            );
          },
        )
      ],
    );
  }
}

class TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const TimeSlotChip({
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
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: CustomText(
            label,
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
