import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  final double width;

  const TagsPage({Key? key, required this.width}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Tags Page'),
      ),
      body: Center(
        child: Container(
          width: widget.width, // Use the provided width
          child: Text('Tags Page Content'),
        ),
      ),
    );
  }
}

