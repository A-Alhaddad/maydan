import 'package:flutter/material.dart';
import 'package:maydan/widgets/my_library.dart';

class OutBoardingIndicator extends StatelessWidget {
  final double marginEnd;
  final bool selected;

  OutBoardingIndicator({this.marginEnd = 0, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: marginEnd),
      width: 10.w,
      height: 10.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.black : Colors.transparent,
          width: 2,
        ),
        color: selected ? AppColors.black : AppColors.black.withOpacity(0.3),
      ),
    );
  }
}