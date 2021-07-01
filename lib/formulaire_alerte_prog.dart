import 'package:flutter/material.dart';
import 'package:mypo/sms_auto.dart';
import 'package:mypo/sms_prog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

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
  final number = TextEditingController();
  final alertContent = TextEditingController();
  bool repeat = false;
  bool rebours = false;
  bool confirm = false;
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false];
  bool SMS = false;
  bool Tel = false;
  bool MMS = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alertContent.dispose();
    number.dispose();
    super.dispose();
  }

  Color getColor(bool b) {
    if (b) {
      return d_green;
    }
    return d_darkgray;
  }

  void saveAlert(String title, String content, var days, var cibles) async {
    final pref = await SharedPreferences.getInstance();
    //Alert a = new Alert(title: title, content: content, days: days, cibles: cibles);
    String tmp =
        '{"number":"$title","content":"$content","days":"$days","cibles":"$cibles","active":false}';
    pref.setString("PROG_" + title, tmp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarA(),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  controller: number,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: d_green)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: "Ajoutez un numero de telephone",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: alertContent,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: d_green)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "Contenu du message",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: d_lightgray,
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => {
                          setState(() {
                            if (!SMS) {
                              this.SMS = true;
                            } else {
                              this.SMS = false;
                            }
                          })
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: getColor(SMS),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text("SMS"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: d_lightgray,
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => {
                          setState(() {
                            if (!Tel) {
                              this.Tel = true;
                            } else {
                              this.Tel = false;
                            }
                          })
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: getColor(Tel),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text("TEL"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: d_lightgray,
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => {
                          setState(() {
                            if (!MMS) {
                              this.MMS = true;
                            } else {
                              this.MMS = false;
                            }
                          })
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: getColor(MMS),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text("MMS"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text("Repeter"),
                    margin: EdgeInsets.fromLTRB(5, 0, 280 - 1.6, 0),
                  ),
                  Switch(
                      activeColor: d_green,
                      value: repeat,
                      onChanged: (bool val) => {
                            setState(() {
                              repeat = val;
                            })
                          }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text("Compte à rebours"),
                    margin: EdgeInsets.fromLTRB(5, 0, 220 - 4.6, 0),
                  ),
                  Switch(
                      activeColor: d_green,
                      value: rebours,
                      onChanged: (bool val) => {
                            setState(() {
                              rebours = val;
                            })
                          }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text("Confirmer avant envoi"),
                    margin: EdgeInsets.fromLTRB(5, 0, 220 - 29.6, 0),
                  ),
                  Switch(
                      activeColor: d_green,
                      value: confirm,
                      onChanged: (bool val) => {
                            setState(() {
                              confirm = val;
                            })
                          }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: d_lightgray,
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text("Notification"),
                    margin: EdgeInsets.fromLTRB(5, 0, 254, 0),
                  ),
                  Switch(
                      activeColor: d_green,
                      value: confirm,
                      onChanged: (bool val) => {
                            setState(() {
                              confirm = val;
                            })
                          }),
                ],
              ),
            ),
            OutlinedButton(
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new SmsProg()),
                      )
                    },
                child: const Text("Valider", style: TextStyle(color: d_green)))
          ],
        ),
      ),
    );
  }
}
