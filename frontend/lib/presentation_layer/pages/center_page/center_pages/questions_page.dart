import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  final double width;

  const QuestionsPage({Key? key, required this.width}) : super(key: key);

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){}),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Questions Page'),
      ),
      body: Center(
        child: Container(
          width: widget.width, // Use the provided width
          child: Text('Questions Page Content'),
        ),
      ),
    );
  }
}
