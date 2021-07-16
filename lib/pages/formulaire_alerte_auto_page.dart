import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mypo/model/alertkey.dart';
import 'sms_auto_page.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:mypo/model/alert.dart';

const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);
const d_green = Color(0xFFA6C800);
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
  bool _value2 = true;
  var db;
  List<AlertKey> keys = <AlertKey>[];
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

  /**
   * save the alert in the shared prefrences
   */
  void saveAlert(String title, String content, var days, var cibles,
      List<AlertKey> keys) async {
    final pref = await SharedPreferences.getInstance();
    //Alert a = new Alert(title: title, content: content, days: days, cibles: cibles);
    List<String> listK = <String>[];
    for (int i = 0; i < keys.length; i++) {
      listK.add(keys[i].toString());
    }
    String type = Type.message.toString();
    String kstr = json.encode(listK);
    String tmp =
        '{"title":"$title","content":"$content","type":"$type","days":"$days","cibles":"$cibles","active":false,"keys":$kstr}';
    print("alert" + widget.nb.toString());
    pref.setString(title, tmp);
    pref.setInt("nombreAlerte", widget.nb + 1);
  }

  /**
   * change the color of the container of a key depending on the allow value 
   */
  Color getColorDropDown(AlertKey a) {
    if (a.allow) {
      return d_green;
    } else {
      return Colors.grey.shade300;
    }
  }

  Widget weekSelector(BuildContext context) {
    final DateSymbols fr = dateTimeSymbolMap()['fr'];
    return WeekdaySelector(
      weekdays: fr.STANDALONEWEEKDAYS,
      // shortWeekdays: fr.STANDALONENARROWWEEKDAYS,
      shortWeekdays: fr.STANDALONESHORTWEEKDAYS,
      firstDayOfWeek: fr.FIRSTDAYOFWEEK + 1,
      selectedFillColor: d_green,
      fillColor: Colors.white,
      onChanged: (v) {
        setState(() {
          week[v % 7] = !week[v % 7];
        });
      },
      values: week,
    );
  }

  /**
   * build the list and the dropdown for the alert key
   * 
   */
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
            padding: const EdgeInsets.all(0),
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
                          keys.add(new AlertKey(
                              name: keyName.text,
                              contient: _value,
                              allow: _value2));
                          keyName.text = "";
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

        // Showing added keys under the field
        keys.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: keys.length,
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
                                      color: getColorDropDown(keys[index]),
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
                                            child: Text(keys[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                            getContient(keys[index]),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                          ),
                                          IconButton(
                                              //
                                              alignment: Alignment(0, 10),
                                              onPressed: () => {
                                                    setState(() {
                                                      this
                                                          .keys
                                                          .remove(keys[index]);
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBar(title: 'Ajoutez une alerte'),
      body: Scrollbar(
        thickness: 10,
        interactive: true,
        showTrackOnHover: true,
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            // FocusManager.instance.primaryFocus?.unfocus(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildTextField(
                      'Titre', "Ajoutez un titre à l'alerte", alertName, 1),
                  buildTextField(
                      'Contenu', "Contenu du message", alertContent, 1),
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
                                            style: TextStyle(fontSize: 15),
                                          ),
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
                                          title: Text(
                                            "Numéros non enregistrés",
                                            style: TextStyle(fontSize: 15),
                                          ),
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
                                          title: Text(
                                            "SMS reçu",
                                            style: TextStyle(fontSize: 15),
                                          ),
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
                                          value: cibles[0],
                                          onChanged: (bool? value) => {
                                                setState(() {
                                                  cibles[0] = value!;
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
                                          value: cibles[1],
                                          onChanged: (bool? value) => {
                                                setState(() {
                                                  cibles[1] = value!;
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
                      child: Column(children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                weekSelector(context),
                              ],
                            ),
                          ),
                        ),
                      ])),
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
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: d_green,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => {
                      if (alertName.text != '')
                        {
                          saveAlert(alertName.text, alertContent.text, week,
                              cibles, keys),
                        },
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new SmsAuto()),
                      )
                    },
                    child: Text(
                      "Valider",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              // set new state

              // this.contentchanged = true;
              // this.titlechanged = true;
              // this.hasChanged = true;
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
}

enum Week { Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche }
