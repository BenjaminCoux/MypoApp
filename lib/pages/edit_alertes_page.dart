import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mypo/model/alert.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mypo/model/alertkey.dart';
import 'home_page.dart';
import 'sms_auto_page.dart';

// ignore: must_be_immutable
class AlertScreen extends StatefulWidget {
  Alert alerte;
  AlertScreen({required this.alerte});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late final alertName;
  late final alertContent;
  bool hasChanged = false;
  bool titlechanged = false;
  bool contentchanged = false;
  int _value = 1;
  bool _value2 = true;
  final keyName = TextEditingController();

  @override
  void initState() {
    super.initState();
    alertName = TextEditingController(text: widget.alerte.title);
    alertContent = TextEditingController(text: widget.alerte.content);
    alertName.addListener(() {
      changed;
    });
    alertContent.addListener(() {
      changed;
    });
  }

  void changed() {
    this.hasChanged = true;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    alertName.dispose();
    alertContent.dispose();
    keyName.dispose();
    super.dispose();
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
                      value: true,
                    ),
                    DropdownMenuItem(
                      child: Text("N'accepte pas"),
                      value: false,
                    )
                  ],
                  onChanged: (bool? value) {
                    setState(() {
                      _value2 = value!;
                    });
                  },
                  hint: Text("Select item")),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: TextField(
            onSubmitted: (String? txt) => {
              setState(() {
                widget.alerte.keys.add(new AlertKey(
                    name: keyName.text, contient: _value, allow: _value2));
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
        ),
        widget.alerte.keys.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: widget.alerte.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () => {
                                  setState(() {
                                    widget.alerte.keys
                                        .remove(widget.alerte.keys[index]);
                                    this.hasChanged = true;
                                  })
                                },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: BoxDecoration(
                                color: Colors.grey,
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
                              child: Text(widget.alerte.keys[index].name),
                            ))
                      ]);
                })
            : Text("Pas encore de clés pour cette alerte"),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: 'Alerte : ${widget.alerte.title}'),
      body: Container(
        padding: EdgeInsets.all(18),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: <Widget>[
              buildTextField('Nom', '${widget.alerte.title}', alertName),
              SizedBox(height: 35),
              buildTextField(
                  'Message', '${widget.alerte.content}', alertContent),
              SizedBox(height: 35),
              alertKeys(context),
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
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Wrap(children: [
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
                                value: widget.alerte.days[0],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[0] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Mardi"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[1],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[1] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Mercredi"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[2],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[2] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Jeudi"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[3],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[3] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Vendredi"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[4],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[4] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Samedi"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[5],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[5] = value!;
                                      })
                                    }),
                            CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Dimanche"),
                                secondary: Icon(Icons.calendar_today),
                                activeColor: d_green,
                                value: widget.alerte.days[6],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[6] = value!;
                                      })
                                    }),
                          ],
                        ),
                      ),
                    ),
                  ])),
              SizedBox(height: 35),
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
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(children: [
                            Container(
                              child: Text("Cibles",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: d_green,
                                  )),
                            )
                          ])),
                      Container(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    secondary: Icon(Icons.contact_page),
                                    title: Text("Numéros Enregistrés"),
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[0],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[0] = value!;
                                          })
                                        }),
                                CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    secondary: Icon(Icons.sms_rounded),
                                    title: Text("SMS reçu"),
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[1],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[1] = value!;
                                          })
                                        }),
                                CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    secondary: Icon(Icons.call),
                                    title: Text("Appels Manqués"),
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[2],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[2] = value!;
                                          })
                                        }),
                              ],
                            )),
                      ),
                    ],
                  )),
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
                    onPressed: () {
                      save();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new HomePage()));
                    },
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

  /*
  function that crates a text field

  */

  TextField buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (String value) => {
        setState(() {
          this.contentchanged = true;
          this.titlechanged = true;
          this.hasChanged = true;
        })
      },
      maxLines: 2,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: d_green)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: d_darkgray)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: d_darkgray)),
        contentPadding: EdgeInsets.all(8),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: placeholder,
        hintStyle: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
    );
  }

  /*
    -Function that saves the modifications of alerts in shared preferences
  */
  void save() async {
    if (hasChanged) {
      final pref = await SharedPreferences.getInstance();
      print(pref.getString(widget.alerte.title));
      final keys = pref.getKeys();
      //dd
      Iterator<String> it = keys.iterator;
      while (it.moveNext()) {
        if (it.current == widget.alerte.title) {
          pref.remove(it.current);
        }
      }
      String title = widget.alerte.title;
      print(titlechanged);
      print(contentchanged);
      if (titlechanged) {
        title = alertName.text;
      }
      String content = widget.alerte.content;
      if (contentchanged) {
        content = alertContent.text;
      }
      final days = widget.alerte.days;
      final cible = widget.alerte.cibles;
      final b = widget.alerte.active;
      List<AlertKey> a = widget.alerte.keys;
      List<String> aStr = <String>[];
      for (int i = 0; i < a.length; i++) {
        aStr.add(a[i].toString());
      }
      String str = json.encode(aStr);
      String tmp =
          '{"title":"$title","content":"$content","days":"$days","cibles":"$cible","active":$b,"keys":$str}';
      pref.setString(title, tmp);
    }
  }
}
