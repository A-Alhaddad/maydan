import 'dart:async';
import 'package:maydan/server/api_service.dart';
import 'package:maydan/widgets/my_library.dart';
import 'package:maydan/widgets/match_type_tabs.dart';
import 'package:maydan/server/api_service.dart';
import 'package:maydan/page/userPages/service/booking/booking_details_page.dart';

class StadiumDetailsPage extends StatefulWidget {
  final Map<String, dynamic> stadium;
  final String? selectedSportId;
  final bool showBookingFlow;
  final bool showCheckoutFlow;

  const StadiumDetailsPage({
    super.key,
    required this.stadium,
    this.selectedSportId,
    this.showBookingFlow = false,
    this.showCheckoutFlow = false,
  });

  @override
  State<StadiumDetailsPage> createState() => _StadiumDetailsPageState();
}

class _StadiumDetailsPageState extends State<StadiumDetailsPage> {
  late final PageController _pageController;
  Timer? _sliderTimer;
  int _currentIndex = 0;
  late List<String> _images;
  int _selectedDayIndex = -1;
  int _selectedDurationMinutes = 0;
  int? _selectedTimeIndex;
  bool _isAvailabilityLoading = false;
  String? _availabilityError;
  List<_SlotItem> _availableSlots = [];
  int _selectedPayOption = 0;
  int? _selectedSeatIndex;
  String? _lastReservationId;

  @override
  void initState() {
    super.initState();
    _images = _extractImages(widget.stadium);
    _pageController = PageController();
    _startAutoSlide();
    if (widget.showBookingFlow && !widget.showCheckoutFlow) {
      final durations = _extractDurations(widget.stadium);
      if (durations.isNotEmpty) {
        _selectedDurationMinutes = durations.first;
      }
      _selectedDayIndex = 0;
      final days = _buildDays(35);
      if (days.isNotEmpty) {
        _loadAvailabilityForDay(days.first);
      }
    }
    if (widget.showCheckoutFlow) {
      final app = AppGet.to;
      _selectedPayOption = app.bookingPayOption ?? 0;
      _selectedSeatIndex = app.bookingSeatIndex;
    }
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (_images.length <= 1) return;
    _sliderTimer?.cancel();
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      _currentIndex = (_currentIndex + 1) % _images.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCheckout = widget.showCheckoutFlow;
    final isBooking = widget.showBookingFlow && !isCheckout;
    final stadiumName = widget.stadium["name"]?.toString() ?? "الملعب";
    final location = _resolveLocationText(widget.stadium);
    final locationMap = _extractLocationMap(widget.stadium);
    final size = widget.stadium["size"]?.toString() ?? "";
    final amenities = widget.stadium["amenities"];
    final controller = AppGet.to;
    final sports = _resolveSports(widget.stadium);
    final workingDays = _buildWorkingDays(widget.stadium);
    final closedDays = _extractClosedDays(widget.stadium);
    final description = widget.stadium["description"]?.toString() ?? "";
    final priceValue = _parsePrice(
      widget.stadium,
      selectedSportId: widget.selectedSportId,
    );
    final currencyName = _extractCurrencyName(locationMap);
    final hasStadiumData = widget.stadium.isNotEmpty;
    final hourlyPrice = (isBooking || isCheckout)
        ? (controller.selectedStadiumHourlyPrice ?? priceValue)
        : priceValue;
    final checkoutTotalPrice = isCheckout
        ? (controller.bookingTotalPrice ??
            _resolveStoredBookingPrice(controller, hourlyPrice))
        : 0.0;
    final checkoutPlayers = isCheckout
        ? _extractPlayersNumber(
            widget.stadium,
            selectedSportId:
                controller.bookingSportId ?? widget.selectedSportId,
          )
        : 0;
    final bottomPrice = isCheckout
        ? (_selectedPayOption == 1 && checkoutPlayers > 0
            ? checkoutTotalPrice / checkoutPlayers
            : checkoutTotalPrice)
        : (isBooking ? _resolveBookingPrice(hourlyPrice) : hourlyPrice);

    final sliderHeight = (isBooking || isCheckout) ? 140.h : 280.h;

    return Scaffold(
      backgroundColor: AppColors.darkIndigo,
      body: SafeArea(
        bottom: true,
        child: hasStadiumData
            ? SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 130.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSliderHeader(stadiumName, location, sliderHeight),
                    SizedBox(height: 16.h),
                    _buildSportsSection(sports),
                    SizedBox(height: 20.h),
                    if (isBooking)
                      _buildBookingContent(controller, widget.stadium)
                    else if (isCheckout)
                      _buildCheckoutContent(controller, widget.stadium)
                    else ...[
                      SectionHeader(
                        iconName: "icon20",
                        title: "aboutStadium".tr,
                        showMore: false,
                      ),
                      SizedBox(height: 14.h),
                      _infoRow(
                        label: "الموقع",
                        value: location.isNotEmpty ? location : "-",
                      ),
                      _infoRow(
                        label: "المساحة",
                        value: size.isNotEmpty ? size : "-",
                      ),
                      _infoRow(
                        label: "الإضافات",
                        value: _formatAmenities(amenities),
                      ),
                      SizedBox(height: 16.h),
                      _buildWorkingHours(workingDays),
                      SizedBox(height: 12.h),
                      _buildClosedDays(closedDays),
                      if (description.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        CustomText(
                          "وصف الملعب",
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          description,
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.7),
                          textAlign: TextAlign.start,
                        ),
                      ],
                      SizedBox(height: 30.h),
                    ],
                  ],
                ),
              )
            : Center(
                child: CustomText(
                  "لا توجد بيانات للملعب",
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: _buildBottomBar(
            price: bottomPrice,
            currency: currencyName,
            buttonLabel: isCheckout
                ? "goToPayment".tr
                : (isBooking
                    ? "matchReservationContinueBooking".tr
                    : "bookStadiumBtn".tr),
            onTap: () {
              if (isCheckout) {
                _handleCheckoutPayment(controller);
                return;
              }
              if (isBooking) {
                if (!_validateBookingSelection(controller)) return;
                _persistBookingSelection(controller, widget.stadium);
                Get.to(
                  () => StadiumDetailsPage(
                    stadium: widget.stadium,
                    selectedSportId: widget.selectedSportId,
                    showCheckoutFlow: true,
                  ),
                  preventDuplicates: false,
                );
                return;
              }

              final hourly = _parsePrice(
                widget.stadium,
                selectedSportId: widget.selectedSportId,
              );
              controller.selectStadium = widget.stadium;
              controller.selectedStadiumHourlyPrice = hourly;
              Get.to(
                () => StadiumDetailsPage(
                  stadium: widget.stadium,
                  selectedSportId: widget.selectedSportId,
                  showBookingFlow: true,
                ),
                preventDuplicates: false,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSliderHeader(
      String stadiumName, String location, double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26.r),
            child: GestureDetector(
              onTap: () => _openImagesViewer(),
              child: _images.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        _currentIndex = index;
                        setState(() {});
                      },
                      itemBuilder: (context, index) {
                        return CustomPngImageNetwork(
                          imageUrl: _images[index],
                          boxFit: BoxFit.cover,
                          width: double.infinity,
                          height: height,
                        );
                      },
                    )
                  : CustomPngImage(
                      imageName: "stadiumImg",
                      boxFit: BoxFit.cover,
                      width: double.infinity,
                      height: height,
                    ),
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            right: 18.w,
            bottom: 18.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  stadiumName,
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: AppColors.green,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CustomText(
                        location,
                        fontSize: 13.sp,
                        color: Colors.white,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    if (_images.length <= 1) return const SizedBox.shrink();
    return Row(
      children: List.generate(
        _images.length,
        (index) => Container(
          margin: EdgeInsets.only(right: 6.w),
          width: index == _currentIndex ? 16.w : 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: index == _currentIndex
                ? AppColors.green
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildSportsSection(List<_SportItem> sports) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: sports.isEmpty
          ? CustomText(
              "لا توجد رياضات متاحة",
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            )
          : Wrap(
              spacing: 12.w,
              runSpacing: 10.h,
              children: sports.map((sport) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sport.imageUrl.isNotEmpty)
                        CustomPngImageNetwork(
                          imageUrl: sport.imageUrl,
                          width: 18.w,
                          height: 18.w,
                          boxFit: BoxFit.contain,
                        )
                      else if (sport.imageName.isNotEmpty)
                        CustomPngImage(
                          imageName: sport.imageName,
                          width: 18.w,
                          height: 18.w,
                          boxFit: BoxFit.contain,
                        ),
                      if (sport.imageUrl.isNotEmpty ||
                          sport.imageName.isNotEmpty)
                        SizedBox(width: 6.w),
                      CustomText(
                        sport.name,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildBottomBar({
    required double price,
    required String currency,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    final formattedPrice = _formatPrice(price);
    final normalizedCurrency = currency.trim();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 55.h,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      buttonLabel,
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                formattedPrice,
                fontSize: 18.sp,
                color: AppColors.green,
                fontWeight: FontWeight.w700,
              ),
              if (normalizedCurrency.isNotEmpty)
                CustomText(
                  normalizedCurrency,
                  fontSize: 13.sp,
                  color: AppColors.green,
                  fontWeight: FontWeight.w500,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingContent(AppGet controller, Map<String, dynamic> stadium) {
    final days = _buildDays(35);
    final durations = _extractDurations(stadium);
    final selectedDay =
        _selectedDayIndex >= 0 && _selectedDayIndex < days.length
            ? days[_selectedDayIndex]
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MatchTypeTabs(
          items: controller.matchTypesList,
          selectedIndex: controller.selectedMatchTypeIndex,
          onTap: (index) {
            controller.changeMatchType(index);
            setState(() {});
          },
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
                  selected: d == _selectedDurationMinutes,
                  onTap: () {
                    setState(() {
                      _selectedDurationMinutes = d;
                      _selectedTimeIndex = null;
                      _availableSlots = [];
                      _availabilityError = null;
                    });
                    if (selectedDay != null) {
                      _loadAvailabilityForDay(selectedDay);
                    }
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
              final selected = _selectedDayIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                    _selectedTimeIndex = null;
                    _availableSlots = [];
                    _availabilityError = null;
                  });
                  _loadAvailabilityForDay(item);
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
                      color: selected ? AppColors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        item.top.toLowerCase().tr,
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
        else if (_isAvailabilityLoading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: SizedBox(
                width: 26.w,
                height: 26.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.green,
                ),
              ),
            ),
          )
        else if (_availabilityError != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: CustomText(
              _availabilityError!,
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          )
        else if (_availableSlots.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: CustomText(
              "لا توجد أوقات متاحة",
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 10.w;
              final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;
              return Wrap(
                spacing: spacing,
                runSpacing: 10.h,
                children: List.generate(_availableSlots.length, (index) {
                  final slot = _availableSlots[index];
                  final selected = _selectedTimeIndex == index;
                  return _TimeChip(
                    width: itemWidth,
                    label: slot.label,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        if (_selectedTimeIndex == index) {
                          _selectedTimeIndex = null;
                        } else {
                          _selectedTimeIndex = index;
                        }
                      });
                    },
                  );
                }),
              );
            },
          ),
        SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildCheckoutContent(
      AppGet controller, Map<String, dynamic> stadium) {
    final playersNumber = _extractPlayersNumber(
      stadium,
      selectedSportId: controller.bookingSportId ?? widget.selectedSportId,
    );
    final locationMap = _extractLocationMap(stadium);
    final currency = _extractCurrencyName(locationMap);
    final hourlyPrice = controller.selectedStadiumHourlyPrice ??
        _parsePrice(
          stadium,
          selectedSportId: widget.selectedSportId,
        );
    final totalPrice = controller.bookingTotalPrice ??
        _resolveStoredBookingPrice(controller, hourlyPrice);
    final effectivePlayers = playersNumber > 0 ? playersNumber : 1;
    final sharePrice = totalPrice / effectivePlayers;
    final formattedTotal = _formatPrice(totalPrice);
    final formattedShare = _formatPrice(sharePrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          iconName: "icon19",
          title: "pay?".tr,
          showMore: false,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPayOption = 1;
                  });
                },
                child: Container(
                  height: 45.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: _selectedPayOption == 1
                        ? AppColors.green
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          'سأدفع حصتي'.tr,
                          color: _selectedPayOption == 1
                              ? AppColors.black
                              : Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CustomSvgImage(
                        imageName: 'icon120',
                        color: _selectedPayOption == 1
                            ? AppColors.black
                            : Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPayOption = 2;
                  });
                },
                child: Container(
                  height: 45.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: _selectedPayOption == 2
                        ? AppColors.green
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          'سأدفع للجميع'.tr,
                          color: _selectedPayOption == 2
                              ? AppColors.black
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CustomSvgImage(
                        imageName: 'icon121',
                        color: _selectedPayOption == 2
                            ? AppColors.black
                            : Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 26.h),
        if (_selectedPayOption == 1) ...[
          CustomText(
            "سيتم تقسيم سعر الحجز الكلي على عدد اللاعبين ($formattedTotal $currency)",
            fontSize: 13.sp,
            color: Colors.white.withOpacity(0.8),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),
          CustomText(
            "المبلغ المطلوب دفعه الآن هو: $formattedShare $currency",
            fontSize: 14.sp,
            color: AppColors.green,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 18.h),
        ],
        SectionHeader(
          iconName: "icon13",
          title: "matchReservationChoosePlace".tr,
          showMore: false,
        ),
        SizedBox(height: 14.h),
        _buildCheckoutSeatGrid(playersNumber),
        SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildCheckoutSeatGrid(int playersNumber) {
    if (playersNumber <= 0) {
      return CustomText(
        "لا توجد أماكن متاحة",
        fontSize: 13.sp,
        color: Colors.white.withOpacity(0.7),
      );
    }

    final leftCount = (playersNumber / 2).ceil();
    final rightCount = playersNumber - leftCount;
    final leftOuterCount = (leftCount + 1) ~/ 2;
    final leftInnerCount = leftCount ~/ 2;
    final rightInnerCount = rightCount ~/ 2;
    final rightOuterCount = (rightCount + 1) ~/ 2;

    final seats = List.generate(playersNumber, (i) => i + 1);
    final leftOuter = seats.take(leftOuterCount).toList();
    final leftInner = seats.skip(leftOuterCount).take(leftInnerCount).toList();
    final rightInner = seats
        .skip(leftOuterCount + leftInnerCount)
        .take(rightInnerCount)
        .toList();
    final rightOuter = seats
        .skip(leftOuterCount + leftInnerCount + rightInnerCount)
        .take(rightOuterCount)
        .toList();

    return SizedBox(
      height: 260.h,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCheckoutSeatColumn(leftOuter),
                _buildCheckoutSeatColumn(leftInner),
              ],
            ),
          ),
          Container(
            width: 1.5.w,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            height: 220.h,
            color: Colors.white.withOpacity(0.2),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCheckoutSeatColumn(rightInner),
                _buildCheckoutSeatColumn(rightOuter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSeatColumn(List<int> seats) {
    if (seats.isEmpty) {
      return const SizedBox.shrink();
    }
    final MainAxisAlignment alignment;
    if (seats.length == 1) {
      alignment = MainAxisAlignment.center;
    } else if (seats.length == 2) {
      alignment = MainAxisAlignment.spaceEvenly;
    } else {
      alignment = MainAxisAlignment.spaceBetween;
    }
    return Column(
      mainAxisAlignment: alignment,
      children: seats.map(_buildCheckoutSeatTile).toList(),
    );
  }

  Widget _buildCheckoutSeatTile(int seat) {
    final selected = _selectedSeatIndex == seat;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeatIndex = _selectedSeatIndex == seat ? null : seat;
        });
      },
      child: Container(
        width: 75.w,
        height: 75.w,
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.green : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.add,
          size: 28.sp,
          color: selected ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  bool _validateBookingSelection(AppGet controller) {
    if (controller.selectedMatchTypeIndex < 0) {
      _showValidationError("bookingSelectMatchType".tr);
      return false;
    }
    if (_selectedDurationMinutes <= 0) {
      _showValidationError("bookingSelectDuration".tr);
      return false;
    }
    if (_selectedDayIndex < 0) {
      _showValidationError("bookingSelectDay".tr);
      return false;
    }
    if (_selectedTimeIndex == null ||
        _selectedTimeIndex! < 0 ||
        _selectedTimeIndex! >= _availableSlots.length) {
      _showValidationError("bookingSelectTime".tr);
      return false;
    }
    return true;
  }

  bool _validateCheckoutSelection() {
    if (_selectedPayOption <= 0) {
      _showValidationError("bookingSelectPay".tr);
      return false;
    }
    if (_selectedSeatIndex == null || _selectedSeatIndex! <= 0) {
      _showValidationError("bookingSelectSeat".tr);
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    getSheetError(message);
  }

  void _persistBookingSelection(
      AppGet controller, Map<String, dynamic> stadium) {
    final days = _buildDays(35);
    final selectedDay =
        _selectedDayIndex >= 0 && _selectedDayIndex < days.length
            ? days[_selectedDayIndex]
            : null;
    final slot = (_selectedTimeIndex != null &&
            _selectedTimeIndex! >= 0 &&
            _selectedTimeIndex! < _availableSlots.length)
        ? _availableSlots[_selectedTimeIndex!]
        : null;
    final hourlyPrice = controller.selectedStadiumHourlyPrice ??
        _parsePrice(
          stadium,
          selectedSportId: widget.selectedSportId,
        );
    controller.selectStadium = stadium;
    controller.selectedStadiumHourlyPrice = hourlyPrice;
    controller.selectedSportId = int.tryParse(widget.selectedSportId ?? '') ??
        controller.selectedSportId;
    controller.bookingMatchTypeIndex = controller.selectedMatchTypeIndex;
    controller.bookingDurationMinutes = _selectedDurationMinutes;
    controller.bookingDateKey = selectedDay?.dateKey;
    controller.bookingDayLabel = selectedDay?.top;
    controller.bookingTimeLabel = slot?.label;
    controller.bookingTimeStart = slot?.start.toIso8601String();
    controller.bookingTimeEnd = slot?.end.toIso8601String();
    controller.bookingTotalPrice = _resolveBookingPrice(hourlyPrice);
    controller.bookingSportId =
        widget.selectedSportId ?? stadium['sportId']?.toString();
    controller.bookingPlayersNumber = _extractPlayersNumber(
      stadium,
      selectedSportId: controller.bookingSportId,
    );
    controller.bookingPayOption = 0;
    controller.bookingSeatIndex = null;
  }

  void _persistCheckoutSelection(AppGet controller) {
    controller.bookingPayOption = _selectedPayOption;
    controller.bookingSeatIndex = _selectedSeatIndex;
  }

  Future<void> _handleCheckoutPayment(AppGet controller) async {
    if (!_validateCheckoutSelection()) return;
    _persistCheckoutSelection(controller);
    final payload = _buildReservationPayload(controller);
    if (payload == null) return;
    _showPaymentProcessingDialog();
    final results = await Future.wait([
      controller.apiRepository.createReservation(payload),
      Future.delayed(const Duration(seconds: 3)),
    ]);
    if (!mounted) return;
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    final res = results.first;
    if (res is ApiResult<Map<String, dynamic>>) {
      if (!res.success) {
        _showValidationError(res.message ?? 'تعذر إتمام الحجز');
        return;
      }
      final reservationId = _extractReservationId(res.data);
      if (reservationId != null && reservationId.isNotEmpty) {
        _lastReservationId = reservationId;
        controller.bookingReservationId = reservationId;
      }
    } else if (res is ApiResult && !res.success) {
      _showValidationError(res.message ?? 'تعذر إتمام الحجز');
      return;
    }
    _showBookingSuccessDialog();
  }

  Map<String, dynamic>? _buildReservationPayload(AppGet controller) {
    final stadiumId = controller.selectStadium['id'] ?? widget.stadium['id'];
    if (stadiumId == null || stadiumId.toString().isEmpty) {
      _showValidationError('لا توجد بيانات للملعب');
      return null;
    }
    final startAt = _formatReservationDateTime(controller.bookingTimeStart);
    final endAt = _formatReservationDateTime(controller.bookingTimeEnd);
    if (startAt.isEmpty || endAt.isEmpty) {
      _showValidationError("bookingSelectTime".tr);
      return null;
    }
    final sportId = controller.bookingSportId ??
        widget.selectedSportId ??
        controller.selectedSportId?.toString();
    if (sportId == null || sportId.toString().isEmpty) {
      _showValidationError("bookingSelectMatchType".tr);
      return null;
    }
    final slots = controller.bookingPlayersNumber ??
        _extractPlayersNumber(
          widget.stadium,
          selectedSportId: controller.bookingSportId ?? widget.selectedSportId,
        );
    final modeIndex =
        controller.bookingMatchTypeIndex ?? controller.selectedMatchTypeIndex;
    final mode = _resolveReservationMode(modeIndex);
    final paymentMode = _selectedPayOption == 1 ? 'split' : 'full';

    return {
      'reservable_type': 'stadium',
      'reservable_id': stadiumId,
      'mode': mode,
      'sport_id': sportId,
      'start_at': startAt,
      'end_at': endAt,
      'payment_method_id': 1,
      'payment_mode': paymentMode,
      'slots': slots > 0 ? slots : 1,
    };
  }

  String _resolveReservationMode(int index) {
    switch (index) {
      case 1:
        return 'challenge';
      case 2:
        return 'activity';
      case 0:
      default:
        return 'booking';
    }
  }

  String _formatReservationDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    final value = parsed;
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final h = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    final s = value.second.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min:$s';
  }

  void _showPaymentProcessingDialog() {
    Get.dialog(
      Center(
        child: Container(
          width: 220.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.darkIndigo,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2.5,
              ),
              SizedBox(height: 14.h),
              CustomText(
                "جاري الدفع",
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showBookingSuccessDialog() {
    Get.dialog(
      Center(
        child: Container(
          width: 320.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: AppColors.darkIndigo,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.green, width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: AppColors.green,
                    size: 30.sp,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              CustomText(
                "تم الحجز بنجاح",
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final reservationId =
                            _lastReservationId ?? AppGet.to.bookingReservationId;
                        if (reservationId == null || reservationId.isEmpty) {
                          _showValidationError('تعذر العثور على رقم الحجز');
                          return;
                        }
                        Get.back();
                        Get.offAll(() => BookingDetailsPage(
                              reservationId: reservationId,
                            ));
                      },
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          "عرض الحجز",
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        AppGet.to.changeBottomNavUser(indexBottomNav: 0);
                        Get.offAll(() => MainUserScreen());
                      },
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(26.r),
                          border: Border.all(
                            color: AppColors.green.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          "العودة للرئيسية",
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  String? _extractReservationId(Map<String, dynamic>? data) {
    if (data == null) return null;
    final id = data['id'] ?? data['reservation_id'] ?? data['reservationId'];
    return id?.toString();
  }

  Future<void> _loadAvailabilityForDay(_DayItem day) async {
    final stadiumId = widget.stadium['id']?.toString() ?? '';
    if (stadiumId.isEmpty) {
      setState(() {
        _availabilityError = "لا توجد بيانات للملعب";
        _availableSlots = [];
      });
      return;
    }
    final slotMinutes =
        _selectedDurationMinutes > 0 ? _selectedDurationMinutes : 60;
    setState(() {
      _isAvailabilityLoading = true;
      _availabilityError = null;
      _availableSlots = [];
    });

    final from = '${day.dateKey} 00:00:00';
    final to = '${day.dateKey} 23:59:59';
    final res = await AppGet.to.apiRepository.getStadiumAvailability(
      stadiumId: stadiumId,
      from: from,
      to: to,
      slotMinutes: slotMinutes,
    );
    if (!mounted) return;
    if (!res.success) {
      setState(() {
        _isAvailabilityLoading = false;
        _availabilityError = res.message ?? "تعذر تحميل الأوقات";
      });
      return;
    }

    final ranges = _extractAvailabilityRangesFromResponse(res.data, day);
    final slots = _buildSlots(ranges, slotMinutes);
    final filteredSlots = _filterSlotsForDay(slots, day);
    setState(() {
      _availableSlots = filteredSlots;
      _isAvailabilityLoading = false;
    });
  }

  List<_DayItem> _buildDays(int count) {
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

    return List.generate(count, (index) {
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

  List<int> _extractDurations(Map<String, dynamic> stadium) {
    final raw = (stadium['availability'] is Map
            ? (stadium['availability'] as Map)['slot_durations']
            : null) ??
        const [];
    final List<int> list = [];
    if (raw is List) {
      for (final item in raw) {
        final value = int.tryParse(item.toString());
        if (value != null) list.add(value);
      }
    }
    if (list.isEmpty) return [60];
    list.sort();
    return list;
  }

  List<_TimeRange> _extractAvailabilityRangesFromResponse(
      dynamic data, _DayItem day) {
    dynamic payload = data;
    if (payload is Map && payload['data'] != null) {
      payload = payload['data'];
    }
    if (payload is Map && payload['availability'] != null) {
      payload = payload['availability'];
    }
    if (payload is Map && payload['times'] is List) {
      final List<_TimeRange> ranges = [];
      for (final entry in payload['times'] as List) {
        if (entry is! Map) continue;
        final dateValue = entry['date']?.toString();
        if (dateValue == null || !dateValue.startsWith(day.dateKey)) {
          continue;
        }
        final slots = entry['slots'];
        ranges.addAll(_parseRangeList(slots, day.date));
      }
      return ranges;
    }
    if (payload is Map && payload['slots'] != null) {
      return _parseRangeList(payload['slots'], day.date);
    }
    if (payload is List) {
      final bool hasTimes = payload.any(
          (e) => e is Map && (e.containsKey('date') || e.containsKey('slots')));
      if (hasTimes) {
        final List<_TimeRange> ranges = [];
        for (final entry in payload) {
          if (entry is! Map) continue;
          final dateValue = entry['date']?.toString();
          if (dateValue != null && !dateValue.startsWith(day.dateKey)) {
            continue;
          }
          final slots = entry['slots'] ?? entry['times'];
          ranges.addAll(_parseRangeList(slots, day.date));
        }
        return ranges;
      }
    }
    if (payload is Map) {
      final dayData = payload[day.dateKey] ??
          payload[day.dayKey] ??
          payload[day.dayKey.toUpperCase()];
      if (dayData != null) {
        return _parseRangeList(dayData, day.date);
      }
    }
    return _parseRangeList(payload, day.date);
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
    final reservedValue = raw['reserved'];
    if (reservedValue == true || reservedValue?.toString() == 'true') {
      return null;
    }
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

  List<_SlotItem> _filterSlotsForDay(List<_SlotItem> slots, _DayItem day) {
    if (slots.isEmpty) return slots;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
    if (dayDate.isAfter(today)) return slots;
    if (dayDate.isBefore(today)) return [];
    return slots.where((slot) => slot.start.isAfter(now)).toList();
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  double _resolveBookingPrice(double hourlyPrice) {
    if (_selectedDurationMinutes <= 0) return hourlyPrice;
    return hourlyPrice * (_selectedDurationMinutes / 60.0);
  }

  double _resolveStoredBookingPrice(AppGet controller, double hourlyPrice) {
    final duration = controller.bookingDurationMinutes ?? 0;
    if (duration <= 0) return hourlyPrice;
    return hourlyPrice * (duration / 60.0);
  }

  int _extractPlayersNumber(Map<String, dynamic> stadium,
      {String? selectedSportId}) {
    final sports = stadium['sports'];
    if (sports is List && sports.isNotEmpty) {
      Map<String, dynamic>? selected;
      if (selectedSportId != null && selectedSportId.isNotEmpty) {
        for (final entry in sports) {
          if (entry is! Map) continue;
          final id = entry['id'] ?? entry['sport_id'];
          if (id != null && id.toString() == selectedSportId) {
            selected = Map<String, dynamic>.from(entry);
            break;
          }
        }
      }
      selected ??= sports.first is Map<String, dynamic>
          ? Map<String, dynamic>.from(sports.first as Map<String, dynamic>)
          : null;
      if (selected != null) {
        final raw = selected['players_number'] ??
            selected['playersNumber'] ??
            selected['players'] ??
            selected['slots'];
        final value = int.tryParse(raw?.toString() ?? '');
        if (value != null) return value;
      }
    }
    return 0;
  }

  Widget _buildWorkingHours(List<_WorkingDay> days) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "أوقات العمل الأسبوعية",
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 10.h),
        if (days.isEmpty)
          CustomText(
            "غير متوفر",
            fontSize: 13.sp,
            color: Colors.white.withOpacity(0.7),
          )
        else
          Column(
            children: days.map((day) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: CustomText(
                        day.label,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        day.times.join(" ، "),
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.8),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildClosedDays(List<String> closedDays) {
    final translated = closedDays.map(_translateDayName).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "أوقات العطلة",
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 10.h),
        CustomText(
          translated.isNotEmpty ? translated.join(" ، ") : "لا يوجد",
          fontSize: 13.sp,
          color: Colors.white.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _infoRow({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: CustomText(
              label,
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmenities(dynamic raw) {
    if (raw is List) {
      final labels = raw
          .map((item) => item?.toString() ?? '')
          .where((value) => value.isNotEmpty)
          .toList();
      return labels.isNotEmpty ? labels.join('، ') : '-';
    }
    if (raw is String) {
      final label = raw;
      return label.isNotEmpty ? label : '-';
    }
    return '-';
  }

  void _openImagesViewer() {
    if (_images.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _StadiumImagesDialog(
        images: _images,
        initialIndex: _currentIndex,
      ),
    );
  }

  List<String> _extractImages(Map<String, dynamic> stadium) {
    final List<String> images = [];
    final raw = stadium['images'];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          final url = item['url'] ?? item['path'] ?? item['image'];
          if (url != null && url.toString().isNotEmpty) {
            images.add(url.toString());
          }
        } else if (item is String && item.isNotEmpty) {
          images.add(item);
        }
      }
    }
    final primary = _extractImageValue(stadium['imageUrl']) ??
        _extractImageValue(stadium['image']) ??
        '';
    if (primary.isNotEmpty && !images.contains(primary)) {
      images.insert(0, primary);
    }
    return images;
  }

  String? _extractImageValue(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is Map) {
      final url = raw['url'] ?? raw['path'] ?? raw['image'];
      return url?.toString();
    }
    return raw.toString();
  }

  List<_SportItem> _resolveSports(Map<String, dynamic> stadium) {
    final List<_SportItem> items = [];
    final List<Map<String, dynamic>> catalog = AppGet.to.sportsList;
    final rawSports = stadium['sports'];
    final sportIds = stadium['sportIds'];

    void addFromCatalog(dynamic id) {
      if (id == null) return;
      final match = catalog.firstWhere(
        (s) => s['id']?.toString() == id.toString(),
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        items.add(
          _SportItem(
            id: match['id']?.toString() ?? '',
            name: match['name']?.toString() ?? 'رياضة',
            imageName: match['image']?.toString() ?? '',
            imageUrl: match['imageUrl']?.toString() ?? '',
          ),
        );
      }
    }

    if (rawSports is List) {
      for (final entry in rawSports) {
        if (entry is Map) {
          final id = entry['id'] ?? entry['sport_id'];
          final name = entry['name']?.toString();
          final imageUrl = entry['image']?.toString() ?? '';
          if ((name != null && name.isNotEmpty) || imageUrl.isNotEmpty) {
            items.add(
              _SportItem(
                id: id?.toString() ?? '',
                name: name ?? 'رياضة',
                imageName: '',
                imageUrl: imageUrl,
              ),
            );
          } else {
            addFromCatalog(id);
          }
        } else {
          addFromCatalog(entry);
        }
      }
    }

    if (items.isEmpty && sportIds is List) {
      for (final id in sportIds) {
        addFromCatalog(id);
      }
    }

    final unique = <String, _SportItem>{};
    for (final item in items) {
      if (item.id.isNotEmpty) {
        unique[item.id] = item;
      }
    }
    return unique.values.isNotEmpty ? unique.values.toList() : items;
  }

  List<_WorkingDay> _buildWorkingDays(Map<String, dynamic> stadium) {
    final availability = _availabilityMap(stadium);
    final raw = availability['working_hours'] ??
        availability['workingHours'] ??
        stadium['workingHours'] ??
        stadium['working_hours'];
    if (raw is! Map) return [];
    final List<_WorkingDay> days = [];
    const order = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    for (final key in order) {
      if (!raw.containsKey(key) && !raw.containsKey(key.toUpperCase())) {
        continue;
      }
      final value = raw[key] ?? raw[key.toUpperCase()];
      final label = _dayLabel(key);
      final times = _formatTimes(value);
      if (times.isNotEmpty) {
        days.add(_WorkingDay(label: label, times: times));
      }
    }
    return days;
  }

  List<String> _extractClosedDays(Map<String, dynamic> stadium) {
    final availability = _availabilityMap(stadium);
    final raw = availability['closed_days'] ??
        availability['closedDays'] ??
        stadium['closedDays'] ??
        stadium['closed_days'];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> _availabilityMap(Map<String, dynamic> stadium) {
    final raw = stadium['availability'];
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String _dayLabel(String key) {
    switch (key.toLowerCase()) {
      case 'mon':
        return "dayMon".tr;
      case 'tue':
        return "dayTue".tr;
      case 'wed':
        return "dayWed".tr;
      case 'thu':
        return "dayThu".tr;
      case 'fri':
        return "dayFri".tr;
      case 'sat':
        return "daySat".tr;
      case 'sun':
        return "daySun".tr;
      default:
        return key;
    }
  }

  String _translateDayName(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'mon':
      case 'monday':
        return "dayMon".tr;
      case 'tue':
      case 'tuesday':
        return "dayTue".tr;
      case 'wed':
      case 'wednesday':
        return "dayWed".tr;
      case 'thu':
      case 'thursday':
        return "dayThu".tr;
      case 'fri':
      case 'friday':
        return "dayFri".tr;
      case 'sat':
      case 'saturday':
        return "daySat".tr;
      case 'sun':
      case 'sunday':
        return "daySun".tr;
      default:
        return value;
    }
  }

  List<String> _formatTimes(dynamic raw) {
    final List<String> times = [];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          final from = item['from'] ?? item['start'];
          final to = item['to'] ?? item['end'];
          if (from != null && to != null) {
            times.add('${from.toString()} - ${to.toString()}');
          }
        } else if (item is String) {
          times.add(item);
        }
      }
    } else if (raw is Map) {
      final from = raw['from'] ?? raw['start'];
      final to = raw['to'] ?? raw['end'];
      if (from != null && to != null) {
        times.add('${from.toString()} - ${to.toString()}');
      }
    } else if (raw is String) {
      times.add(raw);
    }
    return times;
  }

  Map<String, dynamic> _extractLocationMap(Map<String, dynamic> stadium) {
    final rawLocation = stadium['locationData'] ?? stadium['location'];
    if (rawLocation is Map<String, dynamic>) return rawLocation;
    if (rawLocation is Map) return Map<String, dynamic>.from(rawLocation);
    final rawCountry = stadium['countryData'] ?? stadium['country'];
    if (rawCountry is Map<String, dynamic>) return rawCountry;
    if (rawCountry is Map) return Map<String, dynamic>.from(rawCountry);
    return {};
  }

  String _resolveLocationText(Map<String, dynamic> stadium) {
    final rawLocation = stadium['location'];
    if (rawLocation is String && rawLocation.trim().isNotEmpty) {
      return rawLocation.trim();
    }
    if (rawLocation is Map) {
      final address = rawLocation['address']?.toString().trim();
      final city = rawLocation['city']?.toString().trim();
      final country = rawLocation['country']?.toString().trim();
      final parts = [address, city, country]
          .where((value) => value != null && value.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        return parts.join('، ');
      }
    }
    final locationMap = _extractLocationMap(stadium);
    final address = locationMap['address']?.toString().trim();
    final city =
        locationMap['city']?.toString().trim() ?? stadium['city']?.toString();
    final country = locationMap['country']?.toString().trim() ??
        stadium['country']?.toString();
    final parts = [address, city, country]
        .where((value) => value != null && value.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.join('، ') : '';
  }

  String _extractCurrencyName(Map<String, dynamic> locationMap) {
    final name = locationMap['currency_name'] ?? locationMap['currencyName'];
    if (name != null && name.toString().isNotEmpty) {
      return name.toString();
    }
    final code = locationMap['currency'] ?? locationMap['currencyCode'];
    return code?.toString() ?? 'ريال';
  }

  double _parsePrice(Map<String, dynamic> stadium, {String? selectedSportId}) {
    if (selectedSportId != null && selectedSportId.isNotEmpty) {
      final sports = stadium['sports'];
      if (sports is List) {
        for (final entry in sports) {
          if (entry is Map) {
            final id = entry['id'] ?? entry['sport_id'];
            if (id != null && id.toString() == selectedSportId) {
              final raw =
                  entry['hour_price'] ?? entry['hourPrice'] ?? entry['price'];
              final value = double.tryParse(raw?.toString() ?? '');
              if (value != null) return value;
            }
          }
        }
      }
    }
    final raw =
        stadium['price'] ?? stadium['hour_price'] ?? stadium['hourPrice'];
    final value = double.tryParse(raw?.toString() ?? '');
    return value ?? 0;
  }

  String _formatPrice(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0.00';
    }
    return value.toStringAsFixed(2);
  }
}

class _SportItem {
  final String id;
  final String name;
  final String imageName;
  final String imageUrl;

  _SportItem({
    required this.id,
    required this.name,
    required this.imageName,
    required this.imageUrl,
  });
}

class _WorkingDay {
  final String label;
  final List<String> times;

  _WorkingDay({required this.label, required this.times});
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
  final double? width;

  const _TimeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel =
        label.contains('-') ? label.split('-').first.trim() : label;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
              displayLabel,
              fontSize: 15.sp,
              color: Colors.white,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _StadiumImagesDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _StadiumImagesDialog({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_StadiumImagesDialog> createState() => _StadiumImagesDialogState();
}

class _StadiumImagesDialogState extends State<_StadiumImagesDialog> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.85),
      insetPadding: EdgeInsets.all(20.w),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _current = index);
            },
            itemBuilder: (context, index) {
              return CustomPngImageNetwork(
                imageUrl: widget.images[index],
                boxFit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 14.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: index == _current ? 16.w : 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: index == _current
                          ? AppColors.green
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
