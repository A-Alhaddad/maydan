import 'package:maydan/page/userPages/service/coaches/coach_schedule_page.dart';
import 'package:maydan/widgets/my_library.dart';

class CoachDetailsPage extends StatelessWidget {
  final Map<String, dynamic> coach;

  const CoachDetailsPage({
    super.key,
    required this.coach,
  });

  @override
  Widget build(BuildContext context) {
    final String name = coach["name"] ?? "";
    final String subtitle = coach["subtitle"] ?? "مدرب كرة قدم - 8 سنوات";
    final String description = coach["description"] ?? "مدرب كرة قدم معتمد بخبرة تفوق 8 سنوات في تدريب اللاعبين من مختلف الأعمار والمستويات.\n\nأخصص برامج تدريبية فردية وجماعية تركّز على تطوير اللياقة البدنية، الفهم التكتيكي، والجاهزية الذهنية داخل الملعب. اشتغلت مع فرق أحياء ومراكز رياضية، وأؤمن أن كل لاعب لديه فرصة حقيقية للتطور إذا حصل على التوجيه المناسب.\n\nإذا كنت تبحث عن تدريب جاد وممتع، احجز جلستك معي وابدأ رحلتك نحو مستوى أعلى.";
    final String rating = coach["rate"]?.toString() ?? "";
    final String image = coach["image"] ?? "coach_1";

    return GetBuilder<AppGet>(
      id: 'CoachDetailsPage',
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.001),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 70.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomBackButton(onTap: () => Get.back(),),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CircleAvatar(
                    radius: 55.r,
                    backgroundImage:
                    AssetImage("assets/images/$image.png"),
                  ),
                  SizedBox(height: 14.h),
                  CustomText(
                    name,
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.h),
                  CustomText(
                    subtitle,
                    fontSize: 14.sp,
                    color: AppColors.green,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        rating,
                        fontSize: 14.sp,
                        color: AppColors.green,
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.star,
                        color: AppColors.green,
                        size: 18.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: CustomText(
                        description,
                        fontSize: 17.sp,
                        color: Colors.white,
                        textAlign: TextAlign.justify,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  CustomMainButton(
                    title: "coachDetailsBookSchedule",
                    onTap: () async {
                      Get.to(()=>CoachSchedulePage(coach: coach));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
