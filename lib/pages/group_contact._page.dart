import 'package:flutter/material.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/model/colors.dart';

class GroupContact extends StatefulWidget {
  @override
  _GroupContactState createState() => _GroupContactState();
}

class _GroupContactState extends State<GroupContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
        title: "Groupes de contact",
        page: () => HomePage(),
      ),
      body: Center(
        child: Column(children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: d_darkgray,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () => {},
              child: Text(
                "+ Ajouter un groupe de contact",
                style: TextStyle(
                    backgroundColor: d_darkgray,
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white,
                    fontFamily: 'calibri'),
              )),
        ]),
      ),
    );
  }
}
