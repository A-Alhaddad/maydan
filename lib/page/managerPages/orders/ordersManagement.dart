import 'package:maydan/widgets/my_library.dart';

import '../../../widgets/notification_Button.dart';
import 'listOrder.dart';

class OrdersManagement extends StatefulWidget {
  const OrdersManagement({super.key});

  @override
  State<OrdersManagement> createState() => _OrderManagerPageState();
}

class _OrderManagerPageState extends State<OrdersManagement> {
  final _newOrdersController = PageController(viewportFraction: 1);
  final _preOrdersController = PageController(viewportFraction: 1);

  int _newIndex = 0;
  int _preIndex = 0;

  // ======= Fake Data (بدّلها ببيانات API عندك) =======

  final List<OrderModel> newOrders = [
    OrderModel(
      title: "proFootball".tr,
      statusKey: "orderStatusDelivered",
      statusType: OrderStatusType.green,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "ball4",
      // assets/images/football.png
      showMetaRow: false,
    ),
    OrderModel(
      title: "proFootball".tr,
      statusKey: "orderStatusDelivered",
      statusType: OrderStatusType.green,
      customer: "محمود حسن",
      ballsCount: 2,
      price: 250,
      imageName: "ball1",
      showMetaRow: false,
    ),
  ];

  final List<OrderModel> preOrders = [
    OrderModel(
      title: "proBasketball".tr,
      statusKey: "orderStatusShipping",
      statusType: OrderStatusType.red,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "ball22",
      showMetaRow: false,
    ),
    OrderModel(
      title: "proBasketball".tr,
      statusKey: "orderStatusShipping",
      statusType: OrderStatusType.red,
      customer: "سعيد المنسي",
      ballsCount: 10,
      price: 250,
      imageName: "ball1",
      showMetaRow: false,
    ),
  ];

  final List<OrderModel> otherOrders = [
    OrderModel(
      title: "proFootball".tr,
      customer: "محمد أحمد",
      ballsCount: 4,
      price: 250,
      imageName: "ball1",
      showMetaRow: true,
      timeRange: "22:30 - 21:00",
      dateText: "10 / 7",
    ),
    OrderModel(
      title: "proBasketball".tr,
      customer: "سعيد المنسي",
      ballsCount: 10,
      price: 250,
      imageName: "ball4",
      showMetaRow: true,
      timeRange: "22:30 - 21:00",
      dateText: "10 / 7",
    ),
  ];

  @override
  void dispose() {
    _newOrdersController.dispose();
    _preOrdersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'OrdersManagement',
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.001),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'orderManagement'.tr,
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
                    SizedBox(
                      height: 20.h,
                    ),
                    SectionHeader(
                      iconName: "icon30",
                      title: "orderNewOrders".tr,
                      showMore: true,
                      onMoreTap: () {
                        Get.to(() => ListOrders(namePage: 'orderNewOrders',));
                      },
                    ),
                    SizedBox(height: 12.h),
                    _sliderBlock(
                      controller: _newOrdersController,
                      items: newOrders,
                      activeIndex: _newIndex,
                      onChanged: (i) => setState(() => _newIndex = i),
                    ),
                    SizedBox(height: 20.h),
                    SectionHeader(
                      iconName: "icon30",
                      title: "orderPreOrders".tr,
                      showMore: true,
                      onMoreTap: () {
                        Get.to(() => ListOrders(namePage: 'orderPreOrders',));
                      },
                    ),
                    SizedBox(height: 12.h),
                    _sliderBlock(
                      controller: _preOrdersController,
                      items: preOrders,
                      activeIndex: _preIndex,
                      onChanged: (i) => setState(() => _preIndex = i),
                    ),
                    SizedBox(height: 20.h),
                    SectionHeader(
                      iconName: "icon30",
                      title: "orderOtherOrders".tr,
                      showMore: true,
                      onMoreTap: () {
                        Get.to(() => ListOrders(namePage: 'orderOtherOrders',));
                      },
                      widgetInSection: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          TagChip(text: "orderBadgeNew".tr),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...List.generate(otherOrders.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: OrderCard(order: otherOrders[i]),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sliderBlock({
    required PageController controller,
    required List<OrderModel> items,
    required int activeIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 140.h,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            onPageChanged: onChanged,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, i) => OrderCard(order: items[i]),
          ),
        ),
        SizedBox(height: 10.h),
        _dots(count: items.length, active: activeIndex),
      ],
    );
  }

  Widget _dots({required int count, required int active}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 18.w : 8.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.green : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(50.r),
          ),
        );
      }),
    );
  }
}

// ================= CARD =================

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.darkIndigo.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CustomPngImage(
                imageName: order.imageName,
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  order.title,
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 10.h),
                if (order.statusKey != null)
                  _statusChip(order.statusKey!.tr, order.statusType),
                SizedBox(
                  height: 10.h,
                ),
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
                                order.customer.toString() ?? "",
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
                                order.ballsCount.toString(),
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      order.price.toString() +
                          ' ' +
                          'matchReservationCurrency'.tr,
                      fontSize: 18.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                if (order.showMetaRow) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _metaItem(
                        icon: Icons.access_time,
                        text: order.timeRange ?? "",
                      ),
                      SizedBox(width: 14.w),
                      _metaItem(
                        icon: Icons.calendar_month,
                        text: order.dateText ?? "",
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, OrderStatusType type) {
    final bg = type == OrderStatusType.green
        ? AppColors.green
        : const Color(0xFFB6241C);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: CustomText(
        text,
        color: Colors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _metaItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14.sp, color: Colors.black),
        ),
        SizedBox(width: 8.w),
        CustomText(
          text,
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

// ================= MODEL =================

enum OrderStatusType { green, red }

class OrderModel {
  final String title;
  final String? statusKey; // translation key
  final OrderStatusType statusType;
  final String customer;
  final int ballsCount;
  final int price;
  final String imageName;
  final bool showMetaRow;
  final String? timeRange;
  final String? dateText;


  OrderModel({
    required this.title,
    this.statusKey,
    this.statusType = OrderStatusType.green,
    required this.customer,
    required this.ballsCount,
    required this.price,
    required this.imageName,
    required this.showMetaRow,
    this.timeRange,
    this.dateText,
  });
}
