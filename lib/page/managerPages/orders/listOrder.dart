import 'package:maydan/widgets/my_library.dart';

import 'ordersManagement.dart';

class ListOrders extends StatelessWidget {
  ListOrders({required this.namePage});

  final String namePage;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'ListOrders',
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            children: [
              SizedBox(
                height: 80.h,
              ),
              Row(
                children: [
                  CustomBackButton(
                    onTap: () => Get.back(),
                  ),
                  Expanded(
                    child: Center(
                      child: CustomText(
                        'allNewRequests'.tr,
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 42.w),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SectionHeader(
                iconName: "icon30",
                title: namePage.tr,
                showMore: false,
                onMoreTap: () {},
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                itemCount: newOrders.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return OrderCard(order: newOrders[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h ,),
              ),
              SizedBox(height: 50.h,)
            ],
          ),
        );
      },
    );
  }

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
}
