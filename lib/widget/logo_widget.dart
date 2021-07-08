import 'package:flutter/material.dart';

/*
    -that class creates the logo in the middle
*/
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          image: DecorationImage(image: AssetImage('assets/images/logo.png'))),
    );
  }
}
