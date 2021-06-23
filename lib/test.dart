import 'package:flutter/material.dart';
import 'package:mypo/helppage.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String value = 'teteet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'screen test',
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  value = text;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HelpScreen(value: value)));
                },
                child: Text("Switch"),
              )
            ]));
  }
}
