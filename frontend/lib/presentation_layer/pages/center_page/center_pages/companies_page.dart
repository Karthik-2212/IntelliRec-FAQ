import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class CompaniesPage extends StatefulWidget {
  final double width;

  const CompaniesPage({Key? key, required this.width}) : super(key: key);

  @override
  _CompaniesPageState createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  List<String> companies = [
    "Google",
    "Amazon",
    "Microsoft",
    "Apple",
    "Facebook",
    "Walmart"
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Companies',
        style: TextStyle(
          fontWeight: FontWeight.bold,
           color: Colors.white,
        ),
        ),
      ),
      body: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blueGrey,
              elevation: 4,
              child: Center(child: Text(companies[index])),
            );
          },
        ),
      )
    );
  }
}
