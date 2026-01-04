import 'package:maydan/widgets/my_library.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerManager extends StatelessWidget {
  const HomeShimmerManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.5),
      highlightColor: AppColors.white,
      direction: ShimmerDirection.ltr,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 220.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 140.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(
              width: 130.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              height: 190.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 125.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 125.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 22.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 60.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _orderCardShimmer(),
            SizedBox(height: 12.h),
            _orderCardShimmer(),
            SizedBox(height: 22.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 80.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _topProductCardShimmer(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _orderCardShimmer() {
    return Container(
      height: 110.h,
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(start: 14.w, end: 10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: 220.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: 260.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProductCardShimmer() {
    return Container(
      height: 86.h,
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(start: 14.w, end: 14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 190.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 110.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
        ],
      ),
    );
  }
}
