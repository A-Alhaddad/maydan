import 'package:maydan/widgets/my_library.dart';
import 'package:maydan/page/userPages/profile/common_list_screen.dart';
import 'package:maydan/page/userPages/profile/profile.dart';

class BookingDetailsPage extends StatefulWidget {
  final String reservationId;

  const BookingDetailsPage({super.key, required this.reservationId});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _reservation;

  @override
  void initState() {
    super.initState();
    _loadReservation();
  }

  Future<void> _loadReservation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final res = await AppGet.to.apiRepository
        .getReservationDetails(widget.reservationId);
    if (!mounted) return;
    if (!res.success) {
      setState(() {
        _isLoading = false;
        _errorMessage = res.message ?? 'تعذر تحميل تفاصيل الحجز';
      });
      return;
    }
    setState(() {
      _isLoading = false;
      _reservation = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToReservations();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.darkIndigo,
        appBar: AppBar(
          backgroundColor: AppColors.darkIndigo,
          elevation: 0,
          title: CustomText(
            "تفاصيل الحجز",
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            onPressed: _goToReservations,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: 26.w,
          height: 26.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.green,
          ),
        ),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                _errorMessage!,
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.8),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: _loadReservation,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: CustomText(
                    "إعادة المحاولة",
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final reservation = _reservation ?? {};
    final reservable = reservation['reservable'] is Map
        ? reservation['reservable'] as Map
        : <String, dynamic>{};
    final stadium = reservable['data'] is Map
        ? reservable['data'] as Map
        : <String, dynamic>{};
    final sport = reservation['sport'] is Map
        ? reservation['sport'] as Map
        : <String, dynamic>{};
    final imageUrl = _extractImageUrl(stadium['images']);
    final stadiumName = stadium['name']?.toString() ?? 'الملعب';
    final location = _formatLocation(stadium);
    final area = stadium['area']?.toString() ?? '';
    final status = _translateStatus(reservation['status']?.toString());
    final mode = _translateMode(reservation['mode']?.toString());
    final paymentMode =
        _translatePaymentMode(reservation['payment_mode']?.toString());
    final price = reservation['price']?.toString() ?? '-';
    final splitAmount = reservation['split_amount']?.toString() ?? '-';
    final slots = reservation['slots']?.toString() ?? '-';
    final availableSlots = reservation['available_slots']?.toString() ?? '-';
    final startAt = _formatDateTime(reservation['start_at']?.toString());
    final endAt = _formatDateTime(reservation['end_at']?.toString());
    final sportName = sport['name']?.toString() ?? '-';
    final playersNumber = sport['players_number']?.toString() ?? '-';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: CustomPngImageNetwork(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 190.h,
                boxFit: BoxFit.cover,
              ),
            ),
          if (imageUrl.isNotEmpty) SizedBox(height: 16.h),
          CustomText(
            stadiumName,
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          if (location.isNotEmpty) ...[
            SizedBox(height: 6.h),
            CustomText(
              location,
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
          if (area.isNotEmpty) ...[
            SizedBox(height: 6.h),
            CustomText(
              'المساحة: $area',
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
          SizedBox(height: 16.h),
          _detailRow('الرياضة', '$sportName ($playersNumber)'),
          _detailRow('الحالة', status),
          _detailRow('نوع الحجز', mode),
          _detailRow('طريقة الدفع', paymentMode),
          _detailRow('السعر', '${price} ${_fallbackCurrency()}'),
          _detailRow('سعر الحصة', '${splitAmount} ${_fallbackCurrency()}'),
          _detailRow('عدد اللاعبين', slots),
          _detailRow('المقاعد المتاحة', availableSlots),
          _detailRow('وقت البداية', startAt),
          _detailRow('وقت النهاية', endAt),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
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

  String _extractImageUrl(dynamic images) {
    if (images == null) return '';
    if (images is String) return images;
    if (images is Map) {
      final url = images['url'] ?? images['path'] ?? images['image'];
      return url?.toString() ?? '';
    }
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map) {
        final url = first['url'] ?? first['path'] ?? first['image'];
        return url?.toString() ?? '';
      }
      return first.toString();
    }
    return '';
  }

  String _formatLocation(Map stadium) {
    final city = stadium['city']?.toString();
    final country = stadium['country']?.toString();
    final parts = [
      if (city != null && city.isNotEmpty) city,
      if (country != null && country.isNotEmpty) country,
    ];
    return parts.join('، ');
  }

  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    final h = parsed.hour.toString().padLeft(2, '0');
    final min = parsed.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }

  String _fallbackCurrency() {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? 'ريال' : 'OMR';
  }

  String _translateStatus(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final value = raw.toLowerCase();
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';
    const arMap = {
      'pending': 'قيد الانتظار',
      'confirmed': 'مؤكد',
      'cancelled': 'ملغي',
      'canceled': 'ملغي',
      'completed': 'مكتمل',
    };
    const enMap = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'cancelled': 'Cancelled',
      'canceled': 'Canceled',
      'completed': 'Completed',
    };
    return isAr ? (arMap[value] ?? raw) : (enMap[value] ?? raw);
  }

  String _translateMode(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final value = raw.toLowerCase();
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';
    const arMap = {
      'booking': 'مباراة',
      'challenge': 'تحدي',
      'activity': 'نشاط',
    };
    const enMap = {
      'booking': 'Match',
      'challenge': 'Challenge',
      'activity': 'Activity',
    };
    return isAr ? (arMap[value] ?? raw) : (enMap[value] ?? raw);
  }

  String _translatePaymentMode(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final value = raw.toLowerCase();
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';
    const arMap = {
      'split': 'تقسيم',
      'full': 'كامل',
    };
    const enMap = {
      'split': 'Split',
      'full': 'Full',
    };
    return isAr ? (arMap[value] ?? raw) : (enMap[value] ?? raw);
  }

  void _goToReservations() {
    final canPop = Get.key?.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back();
      return;
    }
    Get.offAll(
      () => CommonListPage(
        title: "OldReservations".tr,
        items: AppGet.to.matchesFilter,
        itemBuilder: (item) => PreviousBookingCard(
          match: item,
          typeList: "OldReservations",
        ),
        onHeaderTap: () {
          AppGet.to.changeBottomNavUser(indexBottomNav: 2);
          Get.offAll(() => MainUserScreen());
        },
      ),
    );
  }
}
