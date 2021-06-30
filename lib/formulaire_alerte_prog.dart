import 'package:flutter/material.dart';
import 'package:mypo/sms_auto.dart';

import 'package:shared_preferences/shared_preferences.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class TopBarA extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          Text('Ajoutez une alerte', style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
    );
  }
}

class ProgForm extends StatefulWidget {
  @override
  _ProgState createState() => _ProgState();
}

class _ProgState extends State<ProgForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarA(),
      body: Center(
        child: Column(
          children: [Text("CEci est le formulaire")],
        ),
      ),
    );
  }
}
