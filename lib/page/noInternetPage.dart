import 'package:maydan/widgets/my_library.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppGet>(
        id: 'NoInternetPage',
        builder: (controller) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    CustomPngImage(
                      imageName: 'background',
                      width: double.infinity,
                      height: double.infinity,
                      boxFit: BoxFit.fill,
                    ),
                    Center(
                      child: CustomPngImage(
                        imageName: '404',
                      ),
                    )
                  ],
                ),
                // child: CustomPngImage(imageName: '404',),
              ));
        });
  }
}
