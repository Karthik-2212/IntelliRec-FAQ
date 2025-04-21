import 'package:flutter/material.dart';
class UsersPage extends StatefulWidget {
  final double width;

  const UsersPage({Key? key, required this.width}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Users Page'),
      ),
      body: Center(
        child: Container(
          width: widget.width, // Use the provided width
          child: Text('Users Page Content'),
        ),
      ),
    );
  }
}
