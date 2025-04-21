import 'package:flutter/material.dart';
class MessagesPage extends StatefulWidget {
  final double width;

  const MessagesPage({Key? key, required this.width}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Messages Page'),
      ),
      body: Center(
        child: Container(
          width: widget.width, // Use the provided width
          child: Text('Messages Page Content'),
        ),
      ),
    );
  }
}
