import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mypo/widget/appbar_widget.dart';

import 'home_page.dart';

// ignore: must_be_immutable
class SettingsScreenOne extends StatelessWidget {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: 'Parametres'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: d_green,
                  child: ListTile(
                    onTap: () {
                      //Open edit profile
                    },
                    title: Text('Username',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'calibri',
                            fontWeight: FontWeight.w500)),
                    leading: CircleAvatar(backgroundColor: Colors.red),
                    trailing: Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                   
                      ListTile(
                          leading:
                              Icon(FontAwesomeIcons.language, color: d_green),
                          title: Text("Changer la langue"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          }),
                      _buildDivider(),
                      ListTile(
                          leading: Icon(Icons.location_on, color: d_green),
                          title: Text("Changer le theme"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change theme
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Parametres de notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: d_darkgray,
                  ),
                ),
                SwitchListTile(
                  activeColor: d_green,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text('Recevoir des notifications'),
                  onChanged: (bool s) {
                    s = false;
                  },
                ),
                SwitchListTile(
                    activeColor: d_green,
                    contentPadding: EdgeInsets.all(0),
                    value: true,
                    title: Text('Recevoir les nouvelles offres'),
                    onChanged: (val) {}),
                SwitchListTile(
                    activeColor: d_green,
                    contentPadding: EdgeInsets.all(0),
                    value: false,
                    title: Text('Recevoir les notifications de mise à jour'),
                    onChanged: (val) {}),
              ],
            ),
          ),
        
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade400);
  }
}
