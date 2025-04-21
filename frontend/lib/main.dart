import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellirec/presentation_layer/pages/main_page.dart';
import 'dart:ui';
class SharedPageController {
  static PageController controller = PageController(initialPage: 0);
}
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 900) {
            return  MainPage();
          } else {
            // Narrow layout for phones
            return Scaffold(
              backgroundColor: Colors.black,
            );
          }
        },
      ),
      // initialRoute: "/home",
      // getPages: [
      //   GetPage(name: "/home", page:()=>HomePage()),
      // ],
    );
  }
}
