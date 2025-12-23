import 'package:maydan/widgets/my_library.dart';

class TextScreen extends StatelessWidget {
  final String title;

  final String details;

  TextScreen({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
        id: 'TextScreen',
        init: AppGet(),
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
                            title.tr,
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 42.w),
                    ],
                  ),
                  SizedBox(height: 40.h,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: CustomText(
                      details,
                      textAlign: TextAlign.justify,
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,

                    ),
                  )
                ]),
          );
        });
  }
}
