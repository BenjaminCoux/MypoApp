import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';

class GroupContact extends StatefulWidget {
  @override
  _GroupContactState createState() => _GroupContactState();
}

class _GroupContactState extends State<GroupContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBar(title: "Groupes de contact"),
      body: Center(
        child: Column(
          children: [Text("Test")],
        ),
      ),
    );
  }
}
