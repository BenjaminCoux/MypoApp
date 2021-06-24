import 'package:flutter/material.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:mypo/homepage.dart';

import 'package:mypo/sms_auto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My Co\'Laverie', style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
    );
  }
}

// ignore: must_be_immutable
class AlertScreen extends StatefulWidget {
  Alert alerte;
  AlertScreen({required this.alerte});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final alertName = TextEditingController();
  final alertContent = TextEditingController();
  bool hasChanged = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: Text('Alerte ${widget.alerte.title}',
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
              buildTextField('Nom', '${widget.alerte.title}', alertName),
              SizedBox(height: 35),
              buildTextField(
                  'Message', '${widget.alerte.content}', alertContent),
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
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[0],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[0] = value!;
                                      })
                                    }),
                            Text("lundi"),
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[1],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[1] = value!;
                                      })
                                    }),
                            Text("Mardi"),
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[2],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[2] = value!;
                                      })
                                    }),
                            Text("Mercredi"),
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[3],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[3] = value!;
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
                                value: widget.alerte.days[4],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[4] = value!;
                                      })
                                    }),
                            Text("Vendredi"),
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[5],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[5] = value!;
                                      })
                                    }),
                            Text("Samedi"),
                            Checkbox(
                                activeColor: d_green,
                                value: widget.alerte.days[6],
                                onChanged: (bool? value) => {
                                      setState(() {
                                        hasChanged = true;
                                        widget.alerte.days[6] = value!;
                                      })
                                    }),
                            Text("Dimanche"),
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
                            child: Row(
                              children: [
                                Checkbox(
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[0],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[0] = value!;
                                          })
                                        }),
                                Text("Numéros Enregistrés"),
                                Checkbox(
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[1],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[1] = value!;
                                          })
                                        }),
                                Text("SMS reçu"),
                              ],
                            )),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Checkbox(
                                    activeColor: d_green,
                                    value: widget.alerte.cibles[2],
                                    onChanged: (bool? value) => {
                                          setState(() {
                                            hasChanged = true;
                                            widget.alerte.cibles[2] = value!;
                                          })
                                        }),
                                Text("Appels Manqués")
                              ],
                            ),
                          )
                        ],
                      )
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
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

  TextField buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  void save() async {
    if (hasChanged) {
      final pref = await SharedPreferences.getInstance();
      final keys = pref.getKeys();
      Iterator<String> it = keys.iterator;
      while (it.moveNext()) {
        if (it.current == widget.alerte.title) {
          pref.remove(it.current);
        }
      }
      String title = alertName.text;
      String content = alertContent.text;
      final days = widget.alerte.days;
      final cible = widget.alerte.cibles;
      String tmp =
          '{"title":"$title","content":"$content","days":"$days","cibles":"$cible"}';
      pref.setString(title, tmp);
    }
  }
}
