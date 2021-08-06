import 'package:flutter/material.dart';
import 'package:mypo/pages/aide_page.dart';
import 'package:mypo/pages/edit_profile_page.dart';
import 'package:mypo/pages/rapports_page.dart';
import 'package:mypo/pages/parametres_page.dart';

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
        _buildDivider(),
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
        _buildDivider(),
        new ListTile(
          leading: Icon(Icons.settings, color: Colors.black),
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
        _buildDivider(),
        new ListTile(
          leading: Icon(Icons.help_outline, color: Colors.black),
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
        _buildDivider(),
      ]),
    ));
  }
}

Container _buildDivider() {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1,
      color: Colors.transparent);
}
