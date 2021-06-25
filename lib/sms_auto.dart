import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypo/alerte.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/homepage.dart';
import 'package:mypo/menu_item.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class SmsAuto extends StatefulWidget {
  @override
  _SmsAutoState createState() => _SmsAutoState();
}

class _SmsAutoState extends State<SmsAuto> {
  List alerts = <dynamic>[];

  Future<List> readAlert() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    List res = <dynamic>[];
    Set<String> keys = prefs.getKeys();
    Iterator<String> it = keys.iterator;
    String cc;
    while (it.moveNext()) {
      cc = it.current;
      if (cc != "nombreAlerte") {
        res.add(json.decode(prefs.getString(cc) ?? "/"));
        alerts.add(json.decode(prefs.getString(cc) ?? "/"));
      }
    }
    return res;
  }

  @override
  void initState() {
    readAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [Logo(), Alertes(alerts: alerts)],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text('My Co\'Laverie', style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
    );
  }
}

class SwitchButton extends StatefulWidget {
  @override
  _StateSwitchButton createState() => _StateSwitchButton();
}

class _StateSwitchButton extends State<SwitchButton> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: state,
        activeColor: d_green,
        onChanged: (bool s) {
          setState(() {
            state = s;
            print(state);
          });
        });
  }
}

class Alertes extends StatefulWidget {
  List alerts = <dynamic>[];
  Alertes({required this.alerts});
  @override
  _AlertesState createState() => new _AlertesState();
}

class _AlertesState extends State<Alertes> {
  // ignore: unused_field
  List _items = [];
  bool toggleValue = false;
  bool state = true;
  String test = "";
  String all = "-1";
  int num = -1;
  List alertList = [
    {
      'title': 'WIFI',
      'message': 'Voici le mot de passe du WIFI: 00000000000000000000000',
      'device': 'android',
      'days': [true, false, true, true, false, true, false],
      'cible': [true, false, true],
    },
    {
      'title': 'Test',
      'message': 'Voici un message de test',
      'device': 'ios',
      'days': [true, false, true, true, false, true, false],
      'cible': [true, false, true],
    }
  ];
  @override
  void initState() {
    initNb();
    super.initState();
  }

  void delete(var alert) async {
    final pref = await SharedPreferences.getInstance();
    Set<String> keys = pref.getKeys();
    Iterator<String> it = keys.iterator;
    // pref.clear();
    String cc = "";
    int i = 0;
    bool done = false;
    while (it.moveNext() && !done) {
      if (it.current != "nombreAlerte") {
        if (alert["title"] == it.current) {
          pref.remove(it.current);
          done = true;
        }
      }
      i++;
    }
  }

  void initNb() async {
    final prefs = await SharedPreferences.getInstance();
    int tmp = prefs.getInt("nombreAlerte") ?? -1;
    if (tmp == -1) {
      prefs.setInt("nombreAlerte", 0);
    }
  }

  myList(var alerts, int lenght) {
    return lenght > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: alerts.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () => {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AlertScreen(
                                  alerte: new Alert(
                                      title: alerts[index]["title"],
                                      content: alerts[index]["content"],
                                      days: jsonDecode(alerts[index]["days"]),
                                      cibles: jsonDecode(
                                          alerts[index]["cibles"])))),
                        ),
                      },
                  child: Container(
                      margin: EdgeInsets.all(10),
                      height: 106,
                      width: double.infinity,
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

                      //contenu dans chaque container

                      child: Column(children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  alerts[index]["title"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'calibri',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Column(children: [
                                  SwitchButton(),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => {
                                      setState(() {
                                        delete(alerts[index]);
                                        alerts.remove(alerts[index]);
                                      }),
                                    },
                                  ),
                                ])
                              ],
                            ))
                      ])));
            })
        : const Text("Aucune alerte");
  }

  Future<List> callAsyncFetch() =>
      Future.delayed(Duration(milliseconds: 1), () => widget.alerts);
  @override
  Widget build(BuildContext context) {
    print("hello");
    for (int i = 0; i < widget.alerts.length; i++) {
      print(widget.alerts[i]);
    }
    /*final tmp = alerts[0];
    final test = tmp;
    final tst = json.decode(test);
    print(tst["title"]);*/
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
            height: 30,
            child: Row(children: [Text('Mes Alertes')]),
          ),
          Column(
              //on utilise pas les crochets pour children car on va generer une liste
              children: [
                FutureBuilder(
                    future: callAsyncFetch(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            child: myList(widget.alerts, widget.alerts.length));
                      } else {
                        return CircularProgressIndicator(
                          color: d_green,
                        );
                      }
                    }),
              ]),
          SizedBox(height: 50),
          Center(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: d_darkgray,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: _onButtonPressed,
                child: Text(
                  "+ Ajouter une alerte",
                  style: TextStyle(
                      backgroundColor: d_darkgray,
                      fontSize: 16,
                      letterSpacing: 2.2,
                      color: Colors.white,
                      fontFamily: 'calibri'),
                )),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed() {
    int nb = 0;
    void getNb() async {
      final pref = await SharedPreferences.getInstance();
      nb = pref.getInt("nombreAlerte")!;
    }

    getNb();

    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
                /* 
                        fonction to chose a device
                        */
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.whatsapp,
                ),
                title: Text('WhatsApp'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebookMessenger),
                title: Text('Messenger'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebook),
                title: Text('Facebook'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.instagram),
                title: Text('Instagram'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
            ],
          );
        });
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );
}

// ignore: must_be_immutable
class BottomNavigationBarSection extends StatelessWidget {
  final String value = 'test';
  int nb = 0;
  void getNb() async {
    final pref = await SharedPreferences.getInstance();
    nb = pref.getInt("nombreAlerte")!;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: d_green,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.access_time,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomePage()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new FormScreen(nb: nb)),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new HelpScreen(value: value)),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
