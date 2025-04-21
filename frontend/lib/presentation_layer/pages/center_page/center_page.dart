import 'package:flutter/material.dart';
import '../../../main.dart';
import '../main_page.dart';
import 'center_pages/companies_page.dart';
import 'center_pages/messages_page.dart';
import 'center_pages/questions_page.dart';
import 'center_pages/tags_page.dart';
import 'center_pages/users_page.dart';
import 'center_pages/home_page.dart';
class CenterPage extends StatelessWidget {
  final double width;

  const CenterPage({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: PageView(
            controller: SharedPageController.controller,
            children: [
              HomePage(width: width), // Pass width to HomePage
              QuestionsPage(
                width: width,
              ),
              CompaniesPage(
                width: width,
              ),
              MessagesPage(
                width: width,
              ),
              TagsPage(
                width: width,
              ),
              UsersPage(
                width:width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
