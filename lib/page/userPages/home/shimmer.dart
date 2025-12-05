import 'package:maydan/widgets/my_library.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(

      baseColor: Colors.white.withOpacity(0.5),
      highlightColor: AppColors.white,
      direction: ShimmerDirection.ltr,
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Container(
                        width: 100.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  height: 110.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (_, __) => Container(
                      width: 110.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.w,
                      height: 30.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    Container(
                      width: 80.w,
                      height: 30.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 150.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: 2,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, __) => Container(
                      width: 260.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 280.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: 2,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, __) => Container(
                      width: 340.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 160.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount:5,
                    separatorBuilder: (_, __) => SizedBox(width: 16.w),
                    itemBuilder: (_, __) => Container(
                      width: 110.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 54.w,
                            height: 54.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: 70.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: 40.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
