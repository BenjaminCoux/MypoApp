import 'package:flutter/material.dart';
import 'package:mypo/pages/aide_page.dart';
import 'package:mypo/pages/edit_profile_page.dart';
import 'package:mypo/pages/rapports_page.dart';
import 'package:mypo/pages/parametres_page.dart';
import 'package:mypo/widget/divider_widget.dart';

class HamburgerMenu extends StatefulWidget {
  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Colors.white,
      child: ListView(children: <Widget>[
        new ListTile(
          leading: Icon(Icons.account_box, color: Colors.black),
          title: new Text("Compte", style: TextStyle(color: Colors.black)),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new EditProfilePage()));
          },
        ),
        buildDividerTransparent(),
        new ListTile(
          leading: Icon(Icons.my_library_books_rounded, color: Colors.black),
          title: new Text("Rapport", style: TextStyle(color: Colors.black)),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new RepportsPage()));
          },
        ),
        buildDividerTransparent(),
        new ListTile(
          leading: Icon(Icons.settings_rounded, color: Colors.black),
          title: new Text("Paramètres", style: TextStyle(color: Colors.black)),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new SettingsScreenOne()));
          },
        ),
        buildDividerTransparent(),
        new ListTile(
          leading: Icon(Icons.help_rounded, color: Colors.black),
          title: new Text("Aide", style: TextStyle(color: Colors.black)),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new HelpScreen(value: "TEST")));
          },
        ),
        buildDividerTransparent(),
      ]),
    ));
  }
}
