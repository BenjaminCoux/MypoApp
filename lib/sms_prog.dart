import 'package:flutter/material.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/settings.dart';
import 'package:mypo/sms_auto.dart';
import 'package:mypo/test.dart';

class SmsProg extends StatefulWidget {
  @override
  _SmsProgState createState() => _SmsProgState();
}

class _SmsProgState extends State<SmsProg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Logo(),
        ],
      )),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}
/*
    -that class creates the logo in the middle
*/

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage('images/logo.png'))),
    );
  }
}
