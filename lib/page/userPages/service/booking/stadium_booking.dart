import 'package:maydan/widgets/my_library.dart';

import '../../../../widgets/match_type_tabs.dart';
import '../matches/match_reservation_page.dart';

class StadiumBooking extends StatelessWidget {
  final bool selected;

  StadiumBooking({super.key, this.selected = false});

  int selectedDayIndex = -1;
  Set<int> selectedTimeIndices = {};
  int selectedDurationMinutes = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'StadiumBooking',
      builder: (controller) {
        final app = AppGet.to;
        final List<Map<String, dynamic>> stadiumItems =
            app.stadiums.isNotEmpty ? app.stadiums : const [];
        final days = _buildDays();
        final stadiumForSlots = _resolveStadium(controller, stadiumItems);
        final durations = _extractDurations(stadiumForSlots);
        if (durations.isNotEmpty &&
            (selectedDurationMinutes == 0 ||
                !durations.contains(selectedDurationMinutes))) {
          selectedDurationMinutes = durations.first;
          selectedTimeIndices.clear();
        }
        if (selectedDayIndex >= days.length) {
          selectedDayIndex = -1;
          selectedTimeIndices.clear();
        }
        final selectedDay =
            selectedDayIndex >= 0 && selectedDayIndex < days.length
                ? days[selectedDayIndex]
                : null;
        final availableSlots = selectedDay == null
            ? <_SlotItem>[]
            : _buildSlots(
                _extractAvailabilityRanges(stadiumForSlots, selectedDay),
                selectedDurationMinutes,
              );
        final basePrice = _parsePrice(stadiumForSlots);
        final totalPrice = _calculateTotalPrice(
          basePrice,
          selectedDurationMinutes,
          selectedTimeIndices.length,
        );
        final priceToShow =
            selectedTimeIndices.isNotEmpty ? totalPrice : basePrice;
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
              iconName: "icon18",
              title: "مدة الحجز",
              showMore: false,
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: durations
                  .map(
                    (d) => _DurationChip(
                      label: "$d دقيقة",
                      selected: d == selectedDurationMinutes,
                      onTap: () {
                        selectedDurationMinutes = d;
                        selectedTimeIndices.clear();
                        controller.updateScreen(nameScreen: ['StadiumBooking']);
                      },
                    ),
                  )
                  .toList(),
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
                itemCount: days.length,
                separatorBuilder: (_, __) => SizedBox(width: 20.w),
                itemBuilder: (context, index) {
                  final item = days[index];
                  final selected = selectedDayIndex == index;

                  return GestureDetector(
                    onTap: () {
                      selectedDayIndex = index;
                      selectedTimeIndices.clear();
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
                            item.top,
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          CustomText(
                            item.mid,
                            fontSize: 32.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          CustomText(
                            item.bottom,
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
            if (selectedDay == null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: CustomText(
                  "اختر اليوم لعرض الأوقات المتاحة",
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              )
            else if (availableSlots.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: CustomText(
                  "لا توجد أوقات متاحة",
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              )
            else
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(availableSlots.length, (index) {
                  final slot = availableSlots[index];
                  final selected = selectedTimeIndices.contains(index);
                  return _TimeChip(
                    label: slot.label,
                    selected: selected,
                    onTap: () {
                      if (selectedTimeIndices.contains(index)) {
                        selectedTimeIndices.remove(index);
                      } else {
                        selectedTimeIndices.add(index);
                      }
                      controller.updateScreen(nameScreen: ['StadiumBooking']);
                    },
                  );
                }),
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
                        selectedTimeIndices.clear();
                        selectedDayIndex = -1;
                        final nextDurations = _extractDurations(item);
                        if (nextDurations.isNotEmpty) {
                          selectedDurationMinutes = nextDurations.first;
                        }
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
                                  : (AppGet.to.selectStadium['id']
                                              ?.toString() ==
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
                                                item["location"] ?? "",
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
            if (priceToShow > 0)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      priceToShow.toStringAsFixed(2),
                      fontSize: 18.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      "matchReservationCurrency".tr,
                      fontSize: 14.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            if (priceToShow > 0) SizedBox(height: 12.h),
            CustomMainButton(
              title: "homeActionBook",
              onTap: () async {
                Get.to(
                  () => MatchReservationPage(
                    matchId: selected
                        ? AppGet.to.selectStadium['id']
                        : controller.selectStadium['id'],
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

  List<_DayItem> _buildDays() {
    final now = DateTime.now();
    const weekKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    const weekLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const monthLabels = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    return List.generate(35, (index) {
      final date =
          DateTime(now.year, now.month, now.day).add(Duration(days: index));
      final weekdayIndex = date.weekday - 1;
      return _DayItem(
        date: date,
        dayKey: weekKeys[weekdayIndex],
        top: weekLabels[weekdayIndex],
        mid: '${date.day}',
        bottom: monthLabels[date.month - 1],
        dateKey: _formatDateKey(date),
      );
    });
  }

  String _formatDateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Map<String, dynamic> _resolveStadium(
      AppGet controller, List<Map<String, dynamic>> stadiumItems) {
    if (controller.selectStadium.isNotEmpty) {
      return controller.selectStadium;
    }
    if (stadiumItems.isNotEmpty) {
      return stadiumItems.first;
    }
    return {};
  }

  List<int> _extractDurations(Map<String, dynamic> stadium) {
    final raw =
        stadium['slotDurations'] ?? stadium['slot_durations'] ?? const [];
    final List<int> list = [];
    if (raw is List) {
      for (final item in raw) {
        final value = int.tryParse(item.toString());
        if (value != null) list.add(value);
      }
    }
    if (list.isEmpty) return [30, 60, 90];
    list.sort();
    return list;
  }

  List<_TimeRange> _extractAvailabilityRanges(
      Map<String, dynamic> stadium, _DayItem day) {
    final List<_TimeRange> ranges = [];
    final availability = stadium['availability'];
    if (availability is Map) {
      final dayData = availability[day.dateKey] ??
          availability[day.dayKey] ??
          availability[day.dayKey.toUpperCase()];
      ranges.addAll(_parseRangeList(dayData, day.date));
    } else if (availability is List) {
      for (final entry in availability) {
        if (entry is Map) {
          final entryDate = entry['date']?.toString() ??
              entry['day']?.toString() ??
              entry['day_key']?.toString();
          if (entryDate != null && !_matchesDay(entryDate, day)) {
            continue;
          }
          final range = _parseRangeFromMap(entry, day.date);
          if (range != null) ranges.add(range);
        } else if (entry is String) {
          ranges.addAll(_parseRangeList(entry, day.date));
        }
      }
    }

    if (ranges.isEmpty) {
      final workingHours = stadium['workingHours'] ?? stadium['working_hours'];
      if (workingHours is Map) {
        final dayData =
            workingHours[day.dayKey] ?? workingHours[day.dayKey.toUpperCase()];
        ranges.addAll(_parseRangeList(dayData, day.date));
      }
    }
    return ranges;
  }

  bool _matchesDay(String raw, _DayItem day) {
    final value = raw.toLowerCase();
    if (value.startsWith(day.dateKey)) return true;
    return value == day.dayKey || value.startsWith(day.dayKey);
  }

  List<_TimeRange> _parseRangeList(dynamic raw, DateTime date) {
    final List<_TimeRange> ranges = [];
    if (raw == null) return ranges;
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          final range = _parseRangeFromMap(item, date);
          if (range != null) ranges.add(range);
        } else if (item is String) {
          ranges.addAll(_parseRangeFromString(item, date));
        }
      }
      return ranges;
    }
    if (raw is Map) {
      final range = _parseRangeFromMap(raw, date);
      if (range != null) ranges.add(range);
      return ranges;
    }
    if (raw is String) {
      ranges.addAll(_parseRangeFromString(raw, date));
    }
    return ranges;
  }

  _TimeRange? _parseRangeFromMap(Map raw, DateTime date) {
    final fromRaw = raw['from'] ?? raw['start'] ?? raw['start_at'];
    final toRaw = raw['to'] ?? raw['end'] ?? raw['end_at'];
    return _parseRange(fromRaw?.toString(), toRaw?.toString(), date);
  }

  List<_TimeRange> _parseRangeFromString(String raw, DateTime date) {
    final parts = raw.split('-');
    if (parts.length == 2) {
      final range = _parseRange(parts[0].trim(), parts[1].trim(), date);
      return range == null ? [] : [range];
    }
    return [];
  }

  _TimeRange? _parseRange(String? fromRaw, String? toRaw, DateTime date) {
    final start = _parseDateTime(fromRaw, date);
    final end = _parseDateTime(toRaw, date);
    if (start == null || end == null) return null;
    if (!end.isAfter(start)) return null;
    return _TimeRange(start: start, end: end);
  }

  DateTime? _parseDateTime(String? raw, DateTime date) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();
    if (value.contains('T') || value.contains(' ')) {
      final parsed = DateTime.tryParse(value.replaceFirst(' ', 'T'));
      return parsed;
    }
    if (value.contains(':')) {
      final parts = value.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour == null || minute == null) return null;
        return DateTime(date.year, date.month, date.day, hour, minute);
      }
    }
    return null;
  }

  List<_SlotItem> _buildSlots(List<_TimeRange> ranges, int durationMinutes) {
    if (durationMinutes <= 0) return [];
    final List<_SlotItem> slots = [];
    for (final range in ranges) {
      var cursor = range.start;
      final duration = Duration(minutes: durationMinutes);
      while (cursor.add(duration).isAtSameMomentAs(range.end) ||
          cursor.add(duration).isBefore(range.end)) {
        final end = cursor.add(duration);
        slots.add(
          _SlotItem(
            start: cursor,
            end: end,
            label: '${_formatTime(cursor)} - ${_formatTime(end)}',
          ),
        );
        cursor = end;
      }
    }
    return slots;
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  double _parsePrice(Map<String, dynamic> stadium) {
    final raw =
        stadium['price'] ?? stadium['hour_price'] ?? stadium['hourPrice'];
    final value = double.tryParse(raw?.toString() ?? '');
    return value ?? 0;
  }

  double _calculateTotalPrice(
      double basePricePerHour, int durationMinutes, int slotsCount) {
    if (basePricePerHour <= 0 || durationMinutes <= 0 || slotsCount <= 0) {
      return 0;
    }
    return basePricePerHour * (durationMinutes / 60.0) * slotsCount;
  }
}

class _DayItem {
  final DateTime date;
  final String dayKey;
  final String top;
  final String mid;
  final String bottom;
  final String dateKey;

  const _DayItem({
    required this.date,
    required this.dayKey,
    required this.top,
    required this.mid,
    required this.bottom,
    required this.dateKey,
  });
}

class _TimeRange {
  final DateTime start;
  final DateTime end;

  const _TimeRange({required this.start, required this.end});
}

class _SlotItem {
  final DateTime start;
  final DateTime end;
  final String label;

  const _SlotItem({
    required this.start,
    required this.end,
    required this.label,
  });
}

class _DurationChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: CustomText(
          label,
          fontSize: 13.sp,
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
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
