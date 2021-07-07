import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mypo/model/alert.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/dayselector_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mypo/model/alertkey.dart';
import 'sms_auto_page.dart';

const d_green = Color(0xFFA6C800);

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
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
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
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              padding: EdgeInsets.all(5),
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
            padding: EdgeInsets.all(12),
            child: TextField(
              onSubmitted: (String? txt) => {},
              controller: keyName,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 35,
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
        widget.alerte.keys.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: widget.alerte.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            child: InkWell(
                                onTap: () => {},
                                child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.alerte.keys[index].name,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: 'Alerte : ${widget.alerte.title}'),
      body: Scrollbar(
        thickness: 15,
        interactive: true,
        showTrackOnHover: true,
        child: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                buildTextField('Nom', '${widget.alerte.title}', alertName, 1),
                buildTextField(
                    'Message', '${widget.alerte.content}', alertContent, 3),
                SizedBox(
                  height: 20,
                ),
                alertKeys(context),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
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
                              daySelectorWidget(values: widget.alerte.days),
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
