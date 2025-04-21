import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AppBarr extends StatefulWidget {
  final double height;
  final double width;

  const AppBarr({super.key, required this.height, required this.width});

  @override
  State<AppBarr> createState() => _AppBarState();
}

class _AppBarState extends State<AppBarr> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade500,
            width: 0.1,
          ),
        ),
      ),
      height: 0.05*widget.width,// Use the height from the constructor
      width: widget.width, // Use the width from the constructor
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 200,

          ),
          Container(
            decoration: BoxDecoration(

              color: Color(0xff1b1e27),
              borderRadius: BorderRadius.circular(8),
            ),
            height:0.03*widget.width,
            width: 0.2*widget.width,
            child: Row(
              children: [
                Padding(
                  child: Icon(
                    Icons.search_rounded,
                    color: Color(0xffc0c2cd),
                    size: 0.017*widget.width,
                  ),
                  padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                ),
                Expanded(
                  child: CupertinoTextField(
                    cursorColor: Color(0xffc0c2cd),
                    decoration: null,
                    placeholder: "Search",
                    placeholderStyle: TextStyle(
                      color: Color(0xff6d7079),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(color: Color(0xffc0c2cd), fontSize: 0.013*widget.width),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 0.03*widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff1b1e27),
            ),
            child: Center(
              child: Icon(
                Icons.settings_outlined,
                size: 0.02*widget.width,
                color: Color(0xffc0c2cd),
              ),
            ),
            width:0.03*widget.width,
          ),
          SizedBox(width: 10),
          Container(
            height: 0.03*widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff1b1e27),
            ),
            child: Center(
              child: Icon(
                Icons.notifications_active,
                size: 0.02*widget.width,
                color:  Color(0xffc0c2cd),
              ),
            ),
            width:0.03*widget.width,
          ),
          SizedBox(width: 10),
          Container(
            height: 0.03*widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff1b1e27),
            ),
            child: Center(
              child: Icon(
                Icons.settings_outlined,
                size: 0.02*widget.width,
                color:  Color(0xffc0c2cd),
              ),
            ),
            width:0.03*widget.width,
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
