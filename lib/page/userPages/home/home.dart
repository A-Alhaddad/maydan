import 'dart:convert';

import 'package:maydan/page/userPages/home/shimmer.dart';
import 'package:maydan/widgets/my_library.dart';

import '../../../widgets/notification_Button.dart';
import '../../../widgets/sports_tabs.dart';
import '../service/coaches/coach_details_page.dart';
import '../service/matches/match_reservation_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
      id: 'Home',
      builder: (controller) {
        if (controller.isHomeUserLoading) {
          return const HomeShimmer();
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: RefreshIndicator(
            color: AppColors.green,
            backgroundColor: Colors.black87,
            onRefresh: () async {
              await AppGet.to.loadHomeData(keepSelectedSport: true);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                SliverToBoxAdapter(child: _buildHeader(controller)),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                SliverToBoxAdapter(child: _buildLastMatchCard()),
                SliverToBoxAdapter(child: SizedBox(height: 15.h)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SportsHeaderDelegate(
                    minExtent: 100.h,
                    maxExtent: 100.h,
                    child: Container(
                      color: Colors.transparent,
                      child: SportsTabs(
                        items: controller.sportsList,
                        selectedIndex: controller.selectedSportTapIndex,
                        isLoading: controller.isSportLoading,
                        onTap: controller.changeSport,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 15.h)),
                // SliverToBoxAdapter(child: _buildActionsRow()),
                // SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                SliverToBoxAdapter(child: _buildReservedMatchesSection()),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                SliverToBoxAdapter(child: _buildReservedStadiumsSection()),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                SliverToBoxAdapter(child: _buildCoachesSection()),
                SliverToBoxAdapter(child: SizedBox(height: 120.h)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppGet controller) {
    final userName = controller.userName?.isNotEmpty == true
        ? controller.userName!
        : 'المستخدم';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "${'homeHello'.tr} $userName",
                fontSize: 16.sp,
                color: Colors.white,
              ),
              SizedBox(height: 15.h),
              CustomText(
                "homeReadyTitle".tr,
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

  Widget _buildLastMatchCard() {
    const stadiumName = "ملعب السالمية";
    final lastMatchText = "مباراتك الأخيرة كانت في $stadiumName";

    return GestureDetector(
      onTap: () {
        AppPreferences().getStringValue(key: 'tokenUser').then((value) {
          print(value);
        },);
        printLog('احجز مجدداً');
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomText(
                      lastMatchText,
                      fontSize: 18.sp,
                      color: Colors.white,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkIndigo,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: CustomText(
                      "homeBookAgain".tr,
                      fontSize: 16.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: SizedBox(
                width: 130.w,
                height: 90.h,
                child: CustomPngImage(
                  imageName: 'stadiumImg',
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _actionItem("homeActionSearchMatch", "icon1", 0),
        _actionItem("homeActionCompete", "icon2", 1),
        _actionItem("homeActionTrain", "icon3", 2),
        _actionItem("homeActionBook", "icon4", 3),
      ],
    );
  }

  Widget _actionItem(String textKey, String iconName, int nameOnTap) {
    return GestureDetector(
      onTap: () {
        if (nameOnTap == 0) {
          /// ابحث عن مبارة
          AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 1);
        } else if (nameOnTap == 1) {
          /// نافس
          AppGet.to.changeBottomNavUser(
              indexBottomNav: 1, indexService: 1, selectMatchType: 1);
        } else if (nameOnTap == 2) {
          /// تدرب
          AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 3);
        } else {
          /// احجز ملعب
          AppGet.to.changeBottomNavUser(
              indexBottomNav: 1, indexService: 4, selectMatchType: 0);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Center(
              child: CustomSvgImage(
                imageName: iconName,
                width: 35.w,
                height: 35.w,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 70.w,
            child: CustomText(
              textKey.tr,
              fontSize: 14.sp,
              color: Colors.white,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservedMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          iconName: "icon5",
          title: "homeReservedMatches".tr,
          showMore: true,
          moreText: "homeMore".tr,
          onMoreTap: () {
            printLog('more');
            AppGet.to.changeBottomNavUser(
                indexBottomNav: 1, indexService: 1, selectMatchType: -1);
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 145.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppGet.to.matches.length,
            itemBuilder: (context, index) {
              final item = AppGet.to.matches[index];
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 0 : 12.w,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => MatchReservationPage(
                        matchId: item["id"],
                      ),
                    );
                  },
                  child: _matchCard(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _matchCard(Map<String, dynamic> match) {
    final photoUrl = match["photoUrl"] ?? "";
    return Container(
      width: 350.w,
      constraints: BoxConstraints(minHeight: 150.h),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
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
              width: 100.w,
              height: 100.h,
              child: photoUrl.isNotEmpty
                  ? CustomPngImageNetwork(
                      imageUrl: photoUrl,
                      boxFit: BoxFit.cover,
                    )
                  : CustomPngImage(
                      imageName: match["photo"] ?? "",
                      boxFit: BoxFit.fill,
                    ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  match["name"] ?? "",
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _iconChip(
                        icon: Icons.calendar_month, text: match["date"] ?? ""),
                    SizedBox(width: 10.w),
                    _iconChip(
                        icon: Icons.access_time, text: match["time"] ?? ""),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomSvgImage(
                                imageName: 'icon6',
                                color: AppColors.green,
                                height: 15.h,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: CustomText(
                                  match["available"] ?? "",
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18.sp,
                                color: AppColors.green,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: CustomText(
                                  match["location"] ?? "",
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      match["price"] ?? "",
                      fontSize: 20.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                // SizedBox(height: 2.h,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 6.w),
          CustomText(
            text,
            fontSize: 13.sp,
            color: Colors.white,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildReservedStadiumsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          iconName: "icon8",
          title: "homeReservedStadiums".tr,
          showMore: true,
          moreText: "homeExtraOptions".tr,
          onMoreTap: () {
            printLog('more homeExtraOptions');
            AppGet.to.changeBottomNavUser(
                indexBottomNav: 1, indexService: 4, selectMatchType: 0);
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 320.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppGet.to.stadiums.length,
            itemBuilder: (context, index) {
              final item = AppGet.to.stadiums[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == 0 ? 0 : 12.w,
                ),
                child: GestureDetector(
                    onTap: () {
                      AppGet.to.changeBottomNavUser(
                          indexBottomNav: 1,
                          indexService: 4,
                          selectMatchType: 0,
                          selectStadiumData: item);
                    },
                    child: _stadiumCard(item)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _stadiumCard(Map<String, dynamic> stadium) {
    final imageUrl = stadium["imageUrl"] ?? "";
    final location = stadium;
    printLog(location);
    return Container(
      width: 340.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 190.h,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26.r),
                bottom: Radius.circular(26.r),
              ),
              child: SizedBox(
                height: 190.h,
                width: double.infinity,
                child: imageUrl.isNotEmpty
                    ? CustomPngImageNetwork(
                        imageUrl: imageUrl,
                        boxFit: BoxFit.cover,
                      )
                    : CustomPngImage(
                        imageName: stadium["image"] ?? "",
                        boxFit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  stadium["name"] ?? "",
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 17.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 3.w,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                size: 18.sp,
                                color: AppColors.green,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: CustomText(
                                  stadium["location"] ?? "",
                                  // 'شارع المدينة',
                                  // stadium["location"] ?? "",
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              CustomSvgImage(
                                imageName: 'icon7',
                                color: AppColors.green,
                                height: 18.h,
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                stadium["size"] ?? "",
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              stadium["price"] ?? "",
                              fontSize: 20.sp,
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              "homeCurrencyPerHour".tr,
                              fontSize: 11.sp,
                              color: AppColors.green,
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildCoachesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          iconName: "icon9",
          title: "homeCoachesNearYou".tr,
          showMore: true,
          moreText: "homeExtraOptions".tr,
          onMoreTap: () {
            printLog('more homeExtraOptions coach');
            AppGet.to.changeBottomNavUser(indexBottomNav: 1, indexService: 3);
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppGet.to.coaches.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index == 0 ? 0 : 18.w),
                child: GestureDetector(
                    onTap: () {
                      printLog(AppGet.to.coaches[index]['id']);
                      Get.to(
                        () => CoachDetailsPage(
                          coach: AppGet.to.coaches[index],
                        ),
                      );
                    },
                    child: _coachCard(AppGet.to.coaches[index])),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _coachCard(Map coach) {
    final imageUrl = coach['imageUrl'] ?? '';
    final ImageProvider<Object> avatar = imageUrl.toString().isNotEmpty
        ? NetworkImage(imageUrl) as ImageProvider<Object>
        : AssetImage("assets/images/${coach['image']}.png")
            as ImageProvider<Object>;
    return Container(
      width: 130.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: avatar,
          ),
          SizedBox(height: 8.h),
          CustomText(
            coach["name"],
            fontSize: 15.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                coach["rate"],
                fontSize: 14.sp,
                color: AppColors.green,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: 3.w),
              Icon(Icons.star, color: AppColors.green, size: 14.sp),
            ],
          ),
        ],
      ),
    );
  }
}

class _SportsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _SportsHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isPinned = shrinkOffset > 0;
    final topPad = isPinned ? 20.0 : 0.0;
    final bgColor =
        isPinned ? Colors.black.withOpacity(0.5) : Colors.transparent;
    return SizedBox(
      height: maxExtent,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.only(top: topPad, left: 0, right: 0, bottom: 6.0),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SportsHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}
