import 'package:flutter/material.dart';

import 'homepage.dart';

class HelpScreen extends StatelessWidget {
  final String value;
  HelpScreen({required this.value});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            title: Text('Aide', style: TextStyle(fontFamily: 'calibri')),
            centerTitle: true,
            backgroundColor: d_green),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            title: Text("Question 1"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change password
                            }),
                        _buildDivider(),
                        ListTile(
                            title: Text("Question 2"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change language
                            }),
                        _buildDivider(),
                        ListTile(
                            title: Text("Question 3"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change theme
                            }),
                        _buildDivider(),
                        ListTile(
                            title: Text("Question 4"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change language
                            }),
                        _buildDivider(),
                        ListTile(
                            title: Text("Question 5"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change language
                            }),
                        _buildDivider(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nous contacter',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: d_darkgray,
                    ),
                  ),
                  Text(
                    'Numero :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: d_darkgray,
                    ),
                  ),
                  Text(
                    'Email :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: d_darkgray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Container _buildDivider() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade400);
  }
}
