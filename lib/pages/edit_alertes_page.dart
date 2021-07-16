import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:mypo/model/alert.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mypo/model/alertkey.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'sms_auto_page.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

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
  List<bool> boolWeek = <bool>[];

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
    boolWeek = List<bool>.from(widget.alerte.days);
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

  String getContient(AlertKey a) {
    List<String> contient = [
      "",
      "Contient",
      "Ne contient pas",
      "est au debut",
      "est à la fin",
    ];
    return contient[a.contient];
  }

  Color getColorDropDown(AlertKey a) {
    if (a.allow) {
      return d_green;
    } else {
      return Colors.grey.shade300;
    }
  }

  Widget alertKeys(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              child: DropdownButton(
                  underline: SizedBox(),
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        "Contient",
                      ),
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
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              child: DropdownButton(
                  underline: SizedBox(),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: TextField(
              onChanged: (String value) => {setState(() {})},
              maxLines: 1,
              onSubmitted: (String? txt) => {setState(() {})},
              controller: keyName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add_box_rounded,
                      size: 30,
                      color: d_green,
                    ),
                    onPressed: () {
                      if (keyName.text != '') {
                        setState(() {
                          widget.alerte.keys.add(new AlertKey(
                              name: keyName.text,
                              contient: _value,
                              allow: _value2));
                          keyName.text = "";
                          hasChanged = true;
                        });
                      }
                    }),
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                contentPadding: EdgeInsets.all(8),
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
        ),
        //showing added keys
        widget.alerte.keys.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: widget.alerte.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 55,
                            child: InkWell(
                                onTap: () => {},
                                child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    decoration: BoxDecoration(
                                      color: getColorDropDown(
                                          widget.alerte.keys[index]),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              widget.alerte.keys[index].name,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(getContient(
                                              widget.alerte.keys[index])),
                                          IconButton(
                                              alignment: Alignment.topLeft,
                                              onPressed: () => {
                                                    setState(() {
                                                      widget.alerte.keys.remove(
                                                          widget.alerte
                                                              .keys[index]);
                                                      hasChanged = true;
                                                    })
                                                  },
                                              icon: const Icon(Icons.delete))
                                        ]))))
                      ]);
                })
            : Text("Pas encore de clés pour cette alerte"),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateSymbols fr = dateTimeSymbolMap()['fr'];
    // print(widget.alerte.days);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBar(title: 'Alerte : ${widget.alerte.title}'),
      body: Scrollbar(
        thickness: 10,
        interactive: true,
        showTrackOnHover: true,
        child: Container(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              children: <Widget>[
                buildTextField('Nom', '${widget.alerte.title}', alertName, 1),
                buildTextField(
                    'Message', '${widget.alerte.content}', alertContent, 1),
                Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 5, 5),
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Text(
                            "Cibles",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          )
                        ],
                      )),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    margin: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "Tous",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[0],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[0] =
                                                    value!;
                                              })
                                            }),
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "Numéros non enregistrés",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[1],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[1] =
                                                    value!;
                                              })
                                            }),
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "SMS reçu",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[2],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[2] =
                                                    value!;
                                              })
                                            }),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "Contacts uniquement",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[0],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[0] =
                                                    value!;
                                              })
                                            }),
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "Groupe de contact",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[1],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[1] =
                                                    value!;
                                              })
                                            }),
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                          "Appel manqué",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        activeColor: d_green,
                                        value: widget.alerte.cibles[2],
                                        onChanged: (bool? value) => {
                                              setState(() {
                                                hasChanged = true;
                                                widget.alerte.cibles[2] =
                                                    value!;
                                              })
                                            }),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 5, 5),
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Text(
                            "Jours",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          )
                        ],
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      WeekdaySelector(
                        weekdays: fr.STANDALONEWEEKDAYS,
                        // shortWeekdays: fr.STANDALONENARROWWEEKDAYS,
                        shortWeekdays: fr.STANDALONESHORTWEEKDAYS,
                        firstDayOfWeek: fr.FIRSTDAYOFWEEK + 1,
                        selectedFillColor: d_green,
                        fillColor: Colors.white,
                        onChanged: (v) {
                          setState(() {
                            widget.alerte.days[v % 7] =
                                !widget.alerte.days[v % 7];
                            hasChanged = true;
                          });
                        },
                        values: List<bool>.from(widget.alerte.days),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 5, 5),
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Text(
                            "Contenu du message entrant",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          )
                        ],
                      )),
                ),
                alertKeys(context),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text("Notification après réponses"),
                        margin: EdgeInsets.fromLTRB(
                            5,
                            0,
                            MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.64,
                            0),
                      ),
                      Switch(
                          activeColor: d_green,
                          value: true,
                          onChanged: (bool val) => {
                                setState(() {
                                  // confirm = val;
                                })
                              }),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text("Règle de réponse"),
                        margin: EdgeInsets.fromLTRB(
                            5,
                            0,
                            MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.48,
                            0),
                      ),
                      Switch(
                          activeColor: d_green,
                          value: true,
                          onChanged: (bool val) => {
                                setState(() {
                                  // confirm = val;
                                })
                              }),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SmsAuto()),
                          ),
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: d_green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          save();
                          print(widget.alerte.days);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new SmsAuto()));
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  function that crates a text field

  */

  Container buildTextField(String labelText, String placeholder,
      TextEditingController controller, int nbLines) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: controller,
          onChanged: (String value) => {
            setState(() {
              this.contentchanged = true;
              this.titlechanged = true;
              this.hasChanged = true;
            })
          },
          maxLines: nbLines,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent)),
            contentPadding: EdgeInsets.all(8),
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
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
      Type type = widget.alerte.type;
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
          '{"title":"$title","content":"$content","type":"$type","days":"$days","cibles":"$cible","active":$b,"keys":$str}';
      pref.setString(title, tmp);
    }
  }
}
