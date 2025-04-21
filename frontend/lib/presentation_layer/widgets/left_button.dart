import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeftButton extends StatelessWidget {
  final double screenWidth;
  final String text;
  final IconData imagePath;
  final Color backgroundColor;
  final Color textColor;

  const LeftButton({
    Key? key,
    required this.screenWidth,
    required this.text,
    required this.imagePath,
    required this.backgroundColor ,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0.01 * screenWidth),
      height: 0.032 * screenWidth,
      width: 0.15 * screenWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start, // Aligns content to the left
        children: [
          Icon(
            imagePath,
            color: textColor,
            size: 0.017 * screenWidth,
          ),
          SizedBox(
            width: 0.006 * screenWidth,
          ),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: this.textColor,
              fontSize: 0.01 * screenWidth,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 0.006 * screenWidth,
          ),
        ],
      ),
    );
  }
}
