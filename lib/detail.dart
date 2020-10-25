import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String title;
  DetailPage({this.title});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Text(widget.title),
    );
  }
}
