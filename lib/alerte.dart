import 'package:flutter/material.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:mypo/sms_auto.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

// ignore: must_be_immutable
class AlertScreen extends StatelessWidget {
  Alert alerte;
  AlertScreen({required this.alerte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: Text('Alerte ${alerte.title}',
              style: TextStyle(fontFamily: 'calibri')),
          centerTitle: true,
          backgroundColor: d_green),
      body: Container(
        padding: EdgeInsets.all(18),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: <Widget>[
              buildTextField('Nom', '${alerte.title}'),
              SizedBox(height: 35),
              buildTextField('Message', '${alerte.content}'),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new SmsAuto()),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: d_green,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(String labelText, String placeholder) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: placeholder,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
