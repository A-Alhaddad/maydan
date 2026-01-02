import 'package:maydan/page/managerPages/homeManager/shimmerManager.dart';
import 'package:maydan/page/managerPages/orders/ordersManagement.dart';
import 'dart:math' as math;
import 'package:maydan/widgets/my_library.dart';
import '../../../widgets/notification_Button.dart';

class HomeManager extends StatelessWidget {
  const HomeManager({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'HomeManager',
      builder: (controller) {
        final String seasonText = "24/25";

        if (controller.isHomeUserLoading) {
          return const HomeShimmerManager();
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _buildHeader(controller),
                  SizedBox(height: 33.h),
                  SectionHeader(
                    iconName: "icon29",
                    title: "managerDashboardStatsSection".tr,
                    showMore: false,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          'managerDashboardStatsSection2'.tr,
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      _PillChip(
                        text: "${"managerDashboardSeason".tr} $seasonText",
                        icon: Icons.calendar_month,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _ChartCard(
                    height: 190.h,
                    points: const [
                      0.10,
                      0.22,
                      0.18,
                      0.35,
                      0.26,
                      0.30,
                      0.20,
                      0.45,
                      0.80,
                      0.40,
                      0.55,
                    ],
                    labels: const [
                      "Apr 22",
                      "May 22",
                      "Jun 22",
                      "Jul 22",
                      "Aug 22",
                      "Sep 22",
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.attach_money,
                          value: "250,020.0",
                          titleKey: "managerDashboardTotalSales",
                          deltaText: "+25%",
                          deltaUp: true,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.assignment_outlined,
                          value: "45",
                          titleKey: "managerDashboardTotalOrders",
                          deltaText: "-20%",
                          deltaUp: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  SectionHeader(
                    iconName: "icon30",
                    title: "managerDashboardNewOrders".tr,
                    showMore: true,
                    widgetInSection: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        TagChip(text: "managerDashboardLatest".tr),
                      ],
                    ),
                    moreText: "homeMore".tr,
                    onMoreTap: () {
                      // controller.openOrdersPage?.call();
                    },
                  ),
                  SizedBox(height: 15.h),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.newOrders.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = controller.newOrders[index];
                      return GestureDetector(
                        onTap: () {},
                        child: OrderCard(item: item),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  SectionHeader(
                    iconName: "icon16",
                    title: "managerDashboardMostRequested".tr,
                    showMore: true,
                    widgetInSection: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        TagChip(text: "managerDashboardMostPopular".tr),
                      ],
                    ),
                    moreText: "homeMore".tr,
                    onMoreTap: () {
                      // controller.openOrdersPage?.call();
                    },
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    height: 110.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topProducts.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: _TopProductCard(
                              item: controller.topProducts[index]),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppGet controller) {
    final userName = 'م. عبدالرحيم';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "${'homeHello'.tr} $userName",
                fontSize: 14.sp,
                color: Colors.white,
              ),
              SizedBox(height: 15.h),
              CustomText(
                "managerDashboardTitle".tr,
                fontSize: 24.sp,
                color: AppColors.green,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        NotificationButton(
          onTap: () {
            controller.openNotificationsPage();
          },
        ),
      ],
    );
  }
}

class _PillChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _PillChip({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.white.withOpacity(0.9)),
          SizedBox(width: 8.w),
          CustomText(
            text,
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final double height;
  final List<double> points;
  final List<String> labels;

  const _ChartCard({
    required this.height,
    required this.points,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _LinePainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (t) => CustomText(
                    t,
                    fontSize: 11.sp,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> points;

  _LinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    final int gridCount = 7;
    for (int i = 1; i < gridCount; i++) {
      final x = size.width * (i / gridCount);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    if (points.isEmpty) return;

    final path = Path();
    final double stepX = size.width / math.max(1, points.length - 1);

    Offset p(int i) {
      final v = points[i].clamp(0.0, 1.0);
      final x = i * stepX;
      final y = size.height - (v * size.height);
      return Offset(x, y);
    }

    path.moveTo(p(0).dx, p(0).dy);
    for (int i = 1; i < points.length; i++) {
      final a = p(i - 1);
      final b = p(i);
      final c1 = Offset(a.dx + stepX * 0.5, a.dy);
      final c2 = Offset(b.dx - stepX * 0.5, b.dy);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, b.dx, b.dy);
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < points.length; i++) {
      final pt = p(i);
      canvas.drawCircle(pt, 2.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String titleKey;
  final String deltaText;
  final bool deltaUp;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.titleKey,
    required this.deltaText,
    required this.deltaUp,
  });

  @override
  Widget build(BuildContext context) {
    final deltaColor = deltaUp ? AppColors.green : Colors.red;
    final arrowIcon = deltaUp ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      height: 175.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.green, size: 40.h),
          SizedBox(height: 10.h),
          CustomText(
            value,
            fontSize: 22.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 6.h),
          CustomText(
            titleKey.tr,
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.75),
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(arrowIcon, color: deltaColor, size: 14.sp),
              SizedBox(width: 6.w),
              CustomText(
                deltaText,
                fontSize: 17.sp,
                color: deltaColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel item;

  const OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: SizedBox(
              width: 110.w,
              height: 100.h,
              child: CustomPngImage(
                imageName: item.imageName ?? "ball1",
                boxFit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.title,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomSvgImage(
                                imageName: 'icon32',
                                color: AppColors.green,
                                height: 15.h,
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                item.customer,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomSvgImage(
                                imageName: 'icon33',
                                color: AppColors.green,
                                height: 15.h,
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                "${item.ballsCount.toString()}",
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      item.price.toString() +
                          ' ' +
                          'matchReservationCurrency'.tr,
                      fontSize: 18.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      item.dateText.toString(),
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 14.w),
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.access_time,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      item.timeRange.toString(),
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopProductCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _TopProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290.w,
      padding: EdgeInsetsDirectional.only(start: 14.w, end: 14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58.w,
            child: CustomPngImage(
              imageName: item["image"]?.toString() ?? "ball1",
              width: 50.w,
              height: 50.w,
              boxFit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item["title"]?.toString() ?? "",
                  fontSize: 15.5.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    CustomText(
                      "${item["price"] ?? ""}",
                      fontSize: 15.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      (item["currencyKey"]?.toString() ??
                              "matchReservationCurrency")
                          .tr,
                      fontSize: 12.5.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
