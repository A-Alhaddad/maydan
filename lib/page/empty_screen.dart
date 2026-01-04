import 'package:maydan/widgets/my_library.dart';

class empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
        id: 'nameClass',
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
                children: []),
          );
        });
  }
}
