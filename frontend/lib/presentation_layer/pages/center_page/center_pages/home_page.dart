import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellirec/presentation_layer/widgets/left_button.dart';

class HomePage extends StatefulWidget {
  final double width;

  const HomePage({Key? key, required this.width}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: widget.width, // Use the provided width
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All questions",
                style: GoogleFonts.outfit(
                  fontSize: 0.026*widget.width
                ),
                ),
                LeftButton(
                  textColor: Colors.white,
                  screenWidth: widget.width,
                  text: "Filter",
                  imagePath: Icons.bar_chart,
                  backgroundColor: Color(0xff1b4dd4)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

