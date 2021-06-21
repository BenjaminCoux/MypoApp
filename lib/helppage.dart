import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final String value;
  HelpScreen({required this.value});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" Help page"),
        ),
        body: Center(
          child: Text(value),
        ));
  }
}
