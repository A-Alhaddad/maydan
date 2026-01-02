import 'package:google_fonts/google_fonts.dart';
import 'package:maydan/widgets/my_library.dart';

import '../../../widgets/notification_Button.dart';

class Product extends StatelessWidget {
  Product({super.key});

  String nameCategory = '';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'Product',
      builder: (controller) {
        final categories = controller.addedItemsCategories;

        return Scaffold(

          backgroundColor: Colors.black.withOpacity(0.001),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 73.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'productAndServiceManagement'.tr,
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
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  _TopTabs(
                    selectedIndex: controller.addedItemsTabIndex,
                    onTap: controller.changeAddedItemsTab,
                  ),
                  SizedBox(height: 25.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                    child: SectionHeader(
                      iconName: "icon34",
                      title: "addedItemsSubtitle".tr,
                      showMore: false,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 10.w,
                    ),
                    child: _CategoryRow(
                      items: categories,
                      selectedIndex: controller.addedItemsCategoryIndex,
                      onTap: controller.changeAddedItemsCategory,
                      onAddTap: showAddCategoryBottomSheet,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 12.w , right: 12.w),
                      itemCount: controller.addedItemsTabIndex ==0 ? controller.addedItemsProducts.length: controller.addedItemsService.length,
                      itemBuilder: (context, index) {
                        final item = controller.addedItemsTabIndex ==0 ? controller.addedItemsProducts[index] : controller.addedItemsService[index] ;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: AddedProductCard(
                            title: item["title"]?.toString() ?? "",
                            description: item["desc"]?.toString() ?? "",
                            price: item["price"]?.toString() ?? "",
                            currencyKey: item["currencyKey"]?.toString() ??
                                "matchReservationCurrency",
                            imageName:
                                item["image"]?.toString() ?? "ball_net",
                            showLeftPlus: item["showLeftPlus"] == true,
                            onEdit: () =>
                                controller.openEditProduct(item["id"]),
                            onTap: () =>
                                controller.openProductDetails(item["id"]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned.directional(
                end: 16.w,
                bottom: 20.h,
                textDirection: TextDirection.rtl,
                child: _FloatingAddButton(
                  onTap: showAddProductBottomSheet,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showAddCategoryBottomSheet() async {
    final textController = TextEditingController();

    await Get.bottomSheet(
      const _AddCategorySheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    textController.dispose();
  }

  Future<void> showAddProductBottomSheet() async {
    final result = await Get.bottomSheet(
      const _AddProductSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
    );
  }

}

class _TopTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _TopTabs({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TabItem(
          title: "addedItemsProducts".tr,
          selected: selectedIndex == 0,
          onTap: () => onTap(0),
        ),
        SizedBox(width: 18.w),
        _TabItem(
          title: "addedItemsServices".tr,
          selected: selectedIndex == 1,
          onTap: () => onTap(1),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title,
            fontSize: 18.sp,
            color: selected ? AppColors.green : Colors.white,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 6.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.h,
            width: selected ? 155.w : 0,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const _CategoryRow({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            width: 33.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.add, color: Colors.black, size: 22.sp),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: SizedBox(
            height: 44.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.green
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item["icon"] != null) ...[
                          Icon(
                            item["icon"] as IconData,
                            size: 18.sp,
                            color: selected ? Colors.black : Colors.white,
                          ),
                          SizedBox(width: 10.w),
                        ],
                        CustomText(
                          (item["key"]?.toString() ?? "").tr,
                          fontSize: 15.sp,
                          color: selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AddedProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String currencyKey;
  final String imageName;
  final bool showLeftPlus;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const AddedProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyKey,
    required this.imageName,
    required this.showLeftPlus,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.only(
                start: 16.w, end: 14.w, top: 16.h, bottom: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.14),
                  Colors.white.withOpacity(0.06),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    // color: Colors.black.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: CustomPngImage(
                    imageName: imageName,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 22.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title,
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          description,
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.70),
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            CustomText(
                              price,
                              fontSize: 16.sp,
                              color: AppColors.green,
                              fontWeight: FontWeight.w800,
                            ),
                            SizedBox(width: 6.w),
                            CustomText(
                              currencyKey.tr,
                              fontSize: 14.sp,
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: onEdit,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Spacer(),
                              CustomText(
                                "addedItemsEditProduct".tr,
                                fontSize: 14.sp,
                                color: AppColors.green,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(width: 8.w),
                              Icon(Icons.edit,
                                  size: 18.sp, color: AppColors.green),
                              SizedBox(
                                width: 10.w,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showLeftPlus)
          Positioned(
            left: 14.w,
            top: 60.h,
            child: Container(
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.add, color: Colors.black, size: 30.sp),
            ),
          ),
      ],
    );
  }
}

class _FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.black, size: 34.sp),
      ),
    );
  }
}

class _AddCategorySheet extends StatefulWidget {
  const _AddCategorySheet({super.key});

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // مهم: تجاهل تأثير الكيبورد (البوت شيت ما يتحرك)
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.darkIndigo,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 70.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),

                Row(
                  children: [
                    CustomSvgImage(imageName: 'icon35', height: 28.h, width: 28.w),
                    SizedBox(width: 12.w),
                    CustomText(
                      "addCategoryTitle".tr,
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),

                SizedBox(height: 26.h),
                CustomText(
                  "addCategoryNameLabel".tr,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 12.h),

                Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                     style: GoogleFonts.alexandria(
                    decoration: TextDecoration.none,
                    fontSize:  15.sp,
                    color: Colors.white,
                    // fontWeight: finalWeight,
                  ),
                    cursorColor: AppColors.green,
                    scrollPadding: EdgeInsets.only(bottom: 220.h),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "addCategoryNameHint".tr,
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 16.sp,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                SizedBox(height: 26.h),

                CustomMainButton(
                  title: "addCategoryConfirm", // عندك الزر غالباً بترجم داخلياً
                  showArrow: true,
                  onTap: controller.text.trim().isEmpty
                      ? null
                      : () async {
                    final name = controller.text.trim();
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.back(result: name);
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddProductSheet extends StatefulWidget {
  const _AddProductSheet({super.key});

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  late final TextEditingController nameC;
  late final TextEditingController specsC;
  late final TextEditingController priceC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController();
    specsC = TextEditingController();
    priceC = TextEditingController();
  }

  @override
  void dispose() {
    nameC.dispose();
    specsC.dispose();
    priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // مهم جداً: يمنع الشيت يتحرك بسبب الكيبورد
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.45,
        maxChildSize: 0.96,
        builder: (context, sheetScrollController) {
          final canSubmit = nameC.text.trim().isNotEmpty;

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkIndigo,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Container(
                        width: 70.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Expanded(
                      child: ListView(
                        controller: sheetScrollController,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomSvgImage(
                                imageName: "icon35",
                                height: 26.h,
                                width: 26.w,
                                color: AppColors.green,
                              ),
                              SizedBox(width: 10.w),
                              CustomText(
                                "addProductTitle".tr,
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),

                          _label("addProductNameLabel".tr),
                          SizedBox(height: 10.h),
                          _inputField(
                            controller: nameC,
                            hint: "addProductNameHint".tr,
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 18.h),

                          _label("addProductCategoryLabel".tr),
                          SizedBox(height: 10.h),
                          _fakeDropdown(hint: "addProductCategoryHint".tr),
                          SizedBox(height: 18.h),

                          _label("addProductSpecsLabel".tr),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: _inputField(
                                  controller: specsC,
                                  hint: "addProductSpecsHint".tr,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              _circleIconButton(
                                icon: Icons.add,
                                onTap: () {},
                              ),

                            ],
                          ),
                          SizedBox(height: 10.h),

                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: [
                              _tagChip("sampleTagSoft".tr, onRemove: () {}),
                              _tagChip("sampleTagStrong".tr, onRemove: () {}),
                            ],
                          ),
                          SizedBox(height: 18.h),

                          _label("addProductPriceLabel".tr),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              _circleIconButton(
                                icon: Icons.add,
                                onTap: () {},
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _inputField(
                                  controller: priceC,
                                  hint: "addProductPriceHint".tr,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              _circleIconButton(
                                icon: Icons.remove,
                                onTap: () {},
                                dim: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          _label("addProductImageLabel".tr),
                          SizedBox(height: 10.h),
                          _imagePickerBox(
                            hint: "addProductImageHint".tr,
                            onTap: () {},
                          ),
                          // مساحة احتياط عشان آخر عنصر ما يختفي تحت زر التأكيد
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 14.h),
                      child: CustomMainButton(
                        title: "addProductConfirm".tr,
                        showArrow: true,
                        onTap: canSubmit
                            ? ()async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Get.back(result: {
                            "name": nameC.text.trim(),
                            "specs": specsC.text.trim(),
                            "price": priceC.text.trim(),
                          });
                        }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: CustomText(
        text,
        fontSize: 16.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30.r),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: GoogleFonts.alexandria(
          decoration: TextDecoration.none,
          fontSize:  15.sp,
          color: Colors.white,
          // fontWeight: finalWeight,
        ),
        cursorColor: AppColors.green,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _fakeDropdown({required String hint}) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          CustomText(
            hint,
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.35),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.6)),

        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool dim = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          color: dim ? Colors.white.withOpacity(0.06) : AppColors.green,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: dim ? Colors.white.withOpacity(0.7) : Colors.black,
          size: 22.sp,
        ),
      ),
    );
  }

  Widget _tagChip(String text, {required VoidCallback onRemove}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: Colors.black, size: 16.sp),
          ),
          SizedBox(width: 10.w),
          CustomText(
            text,
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _imagePickerBox({required String hint, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Icon(Icons.image_outlined, color: Colors.white.withOpacity(0.6)),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomText(
                hint,
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

