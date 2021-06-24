import 'package:flutter/material.dart';
import 'package:mypo/homepage.dart';

import 'package:shared_preferences/shared_preferences.dart';

const String pathToDB = "../assets/database.json";
const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

// ignore: must_be_immutable
class FormScreen extends StatefulWidget {
  int nb;
  FormScreen({required this.nb});
  @override
  _FormState createState() => _FormState();
}

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

class _FormState extends State<FormScreen> {
  final alertName = TextEditingController();
  final alertContent = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false];
  var db;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alertContent.dispose();
    alertName.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _onFormSaved() {
    final FormState? form = _formKey.currentState;
    form!.save();
  }

  void saveAlert(String title, String content, var days, var cibles) async {
    final pref = await SharedPreferences.getInstance();
    //Alert a = new Alert(title: title, content: content, days: days, cibles: cibles);
    String tmp = '{"title":"$title","content":"$content","days":"$days","cibles":"$cibles"}';
    print("alert" + widget.nb.toString());
    pref.setString(title, tmp);
    pref.setInt("nombreAlerte", widget.nb + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarA(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    controller: alertName,
                    decoration: InputDecoration(
                        hintText: "Ajoutez un titre à l'alerte"),
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
                      decoration:
                          InputDecoration(hintText: "Contenu du message"),
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
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(children: [
                              Text("Jours",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: d_green,
                                  ))
                            ]))),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: d_green,
                                value: week[0],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[0] = value!;
                                      })
                                    }),
                            Text("lundi"),
                            Checkbox(
                                activeColor: d_green,
                                value: week[1],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[1] = value!;
                                      })
                                    }),
                            Text("Mardi"),
                            Checkbox(
                                activeColor: d_green,
                                value: week[2],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[2] = value!;
                                      })
                                    }),
                            Text("Mercredi"),
                            Checkbox(
                                activeColor: d_green,
                                value: week[3],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[3] = value!;
                                      })
                                    }),
                            Text("Jeudi"),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(11),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: d_green,
                                value: week[4],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[4] = value!;
                                      })
                                    }),
                            Text("Vendredi"),
                            Checkbox(
                                activeColor: d_green,
                                value: week[5],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[5] = value!;
                                      })
                                    }),
                            Text("Samedi"),
                            Checkbox(
                                activeColor: d_green,
                                value: week[6],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        week[6] = value!;
                                      })
                                    }),
                            Text("Dimanche"),
                          ],
                        ),
                      ),
                    ),
                  ])),
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
                  child: Column(children: [
                    Container(
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                "Cibles",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: d_green),
                              )
                            ],
                          )),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: d_green,
                                value: cibles[0],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        cibles[0] = value!;
                                      })
                                    }),
                            Text("Numéros Enregistrés"),
                            Checkbox(
                                activeColor: d_green,
                                value: cibles[1],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        cibles[1] = value!;
                                      })
                                    }),
                            Text("SMS reçu"),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: d_green,
                                value: cibles[2],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        cibles[2] = value!;
                                      })
                                    }),
                            Text("Appels Manqués"),
                          ],
                        ),
                      ),
                    ),
                  ])),
              OutlinedButton(
                  onPressed: () => {
                        saveAlert(
                            alertName.text, alertContent.text, week, cibles),
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new HomePage()),
                        )
                      },
                  child:
                      const Text("Valider", style: TextStyle(color: d_green))),
            ],
          ),
        ),
      ),
    );
  }
}

class Alert {
  String title;
  String content;
  final days;
  final cibles;

  Alert(
      {required this.title,
      required this.content,
      required this.days,
      required this.cibles});
}

enum Week { Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche }
