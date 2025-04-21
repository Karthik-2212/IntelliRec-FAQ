import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:intellirec/main.dart';
import 'package:intellirec/presentation_layer/widgets/app_bar.dart';
import 'package:intellirec/presentation_layer/widgets/left_button.dart';

import 'center_page/center_page.dart';
List<Map<String, dynamic>> menuItems = [
  {
    'icon': Icons.home,
    'text': 'Home',
  },
  {
    'icon': Icons.question_answer,
    'text': 'Questions',
  },
  {
    'icon': Icons.business,
    'text': 'Companies',
  },
  {
    'icon': Icons.label,
    'text': 'Tags',
  },
  {
    'icon': Icons.people,
    'text': 'Users',
  },
];

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _HomePageState();
}
class _HomePageState extends State<MainPage> {
  bool _left_button_clciked=false;
  int _selectedIndex=0;
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(1)
      ),
      child: Scaffold(
        backgroundColor: Color(0xff16151a),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBarr(
              height: screenHeight,
              width: screenWidth,
            ),
            Expanded(child: Container(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                       border: Border(
                         right: BorderSide(
                           color: Colors.grey.shade500,
                           width: 0.1,
                         ),
                       )
                    ),
                    width: 0.18*screenWidth,
                    child:  ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context,index){
                          return
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent, // Disable splash effect
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            onTap: (){
                              SharedPageController.controller.jumpToPage(index);
                              _selectedIndex = index;
                              setState(() {
                              });
                            },
                            child: LeftButton(
                              textColor: Color(0xffc0c2cd),
                                backgroundColor: _selectedIndex==index?Color(0xff1b4dd4):Colors.transparent,
                                screenWidth: screenWidth,
                                text: menuItems[index]['text'],
                                imagePath: menuItems[index]['icon']),
                          ),
                        );
                        }
                    )
                    ),
                  Container(
                    width: 0.5*screenWidth,
                    decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey.shade500,
                            width: 0.1,
                          ),
                        )
                    ),
                    child: CenterPage(
                      width: screenWidth,
                    ),
                  ),
                  Container(
                    width: 0.3*screenWidth,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
