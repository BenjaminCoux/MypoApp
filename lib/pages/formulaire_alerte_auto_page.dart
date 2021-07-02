import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'sms_auto_page.dart';

const String pathToDB = "../assets/database.json";

/*
  -This class creates the screeen to crate a new alor with all the options 
*/
// ignore: must_be_immutable
class FormScreen extends StatefulWidget {
  int nb;
  FormScreen({required this.nb});
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormScreen> {
  final alertName = TextEditingController();
  final alertContent = TextEditingController();
  final keyName = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false];
  int _value = 1;
  int _value2 = 1;
  var db;
  List<String> keys = <String>[];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alertContent.dispose();
    alertName.dispose();
    keyName.dispose();
    keys.clear();
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
    String tmp =
        '{"title":"$title","content":"$content","days":"$days","cibles":"$cibles","active":false}';
    print("alert" + widget.nb.toString());
    pref.setString(title, tmp);
    pref.setInt("nombreAlerte", widget.nb + 1);
  }

  Widget alertKeys(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: DropdownButton(
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("Contient"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Ne Contient pas"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("Est au debut"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("Est à la fin"),
                      value: 4,
                    )
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                    });
                  },
                  hint: Text("Select item")),
            ),
            Container(
              child: DropdownButton(
                  value: _value2,
                  items: [
                    DropdownMenuItem(
                      child: Text("Accepte"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("N'accepte pas"),
                      value: 2,
                    )
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      _value2 = value!;
                    });
                  },
                  hint: Text("Select item")),
            ),
          ],
        ),
        keys.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () => {
                                  setState(() {
                                    this.keys.remove(keys[index]);
                                  })
                                },
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
                              child: Text(keys[index]),
                            ))
                      ]);
                })
            : Text("Pas encore de clés pour cette alerte"),
        Padding(
          padding: EdgeInsets.all(12),
          child: TextField(
            onSubmitted: (String? txt) => {
              setState(() {
                keys.add(keyName.text);
                keyName.text = "";
              })
            },
            controller: keyName,
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
              hintText: "Ajoutez une clé à l'alerte ",
              hintStyle: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Ajoutez une alerte'),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                        hintText: "Ajoutez un titre à l'alerte",
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
                    child: alertKeys(context)),
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
                          child: Column(
                            children: [
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Lundi"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[0],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[0] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Mardi"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[1],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[1] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Mercredi"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[2],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[2] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Jeudi"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[3],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[3] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Vendredi"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[4],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[4] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  secondary: Icon(Icons.calendar_today),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Samedi"),
                                  activeColor: d_green,
                                  value: week[5],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[5] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Dimanche"),
                                  secondary: Icon(Icons.calendar_today),
                                  activeColor: d_green,
                                  value: week[6],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          week[6] = value!;
                                        })
                                      }),
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
                          child: Column(
                            children: [
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  secondary: Icon(Icons.contact_page),
                                  title: Text("Numéros Enregistrés"),
                                  activeColor: d_green,
                                  value: cibles[0],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          cibles[0] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  secondary: Icon(Icons.sms_rounded),
                                  title: Text("SMS reçu"),
                                  activeColor: d_green,
                                  value: cibles[1],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          cibles[1] = value!;
                                        })
                                      }),
                              CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  secondary: Icon(Icons.call),
                                  title: Text("Appels Manqués"),
                                  activeColor: d_green,
                                  value: cibles[2],
                                  onChanged: (bool? value) => {
                                        setState(() {
                                          cibles[2] = value!;
                                        })
                                      }),
                            ],
                          ),
                        ),
                      ),
                    ])),
                OutlinedButton(
                    onPressed: () => {
                          saveAlert(
                              alertName.text, alertContent.text, week, cibles),
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SmsAuto()),
                          )
                        },
                    child: const Text("Valider",
                        style: TextStyle(color: d_green))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
  -alerts are elements of the class Alert
*/

enum Week { Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche }
