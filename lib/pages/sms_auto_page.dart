import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypo/model/alert.dart';
import 'package:mypo/model/alertkey.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'edit_alertes_page.dart';
import 'formulaire_alerte_auto_page.dart';

const d_green = Color(0xFFA6C800);

class SmsAuto extends StatefulWidget {
  @override
  _SmsAutoState createState() => _SmsAutoState();
}

class _SmsAutoState extends State<SmsAuto> {
  List alerts = <dynamic>[];

  Future<List> readAlert() async {
    final prefs = await SharedPreferences.getInstance();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "My Co'Laverie"),
      drawer: HamburgerMenu(),
      body: Scrollbar(
        thickness: 15,
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: SingleChildScrollView(
          child: Column(
            children: [Alertes(alerts: alerts)],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarSmsAutoTwo(),
    );
  }
}

/*
  -Function that handle the switch button of an alert
*/

// ignore: must_be_immutable
class SwitchButton extends StatefulWidget {
  dynamic alerte;
  SwitchButton({required this.alerte});
  @override
  _StateSwitchButton createState() => _StateSwitchButton();
}

class _StateSwitchButton extends State<SwitchButton> {
  bool state = false;

  // ignore: unused_field
  String _message = "";

  final telephony = Telephony.instance;

  /*
    -This function initiate the process of auto messaging
  */
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /*
    -This function do things when we recieve a message on the foreground
    it gets incomming messages 
    Check if it contains any of the keys of activated alerts
    Send back the alert message to the person
  */
  onMessage(SmsMessage message) async {
    List<String> keys = <String>[];
    List contents = <dynamic>[];
    final prefs = await SharedPreferences.getInstance();
    final tmp = prefs.getKeys();
    Iterator<String> it = tmp.iterator;
    while (it.moveNext()) {
      if (it.current != "nombreAlerte") {
        keys.add(it.current);
      }
    }
    contents = await getContents();
    debugPrint("onMessage called (Foreground)");
    int i = 0;
    //si le message reçu contient
    while (i < keys.length) {
      bool tmp = isActive(
          message.body,
          createAlert(
              new Alert(
                  title: contents[i]["title"],
                  content: contents[i]["content"],
                  days: json.decode(contents[i]["days"]),
                  cibles: json.decode(contents[i]["cibles"]),
                  keys: buildKeys(contents[i]["keys"])),
              contents[i]["active"]));
      debugPrint(tmp.toString());
      if (tmp) {
        Telephony.instance.sendSms(
            to: message.address.toString(), message: contents[i]["content"]);
        return;
      }
      i++;
    }
  }

  /*
     This function return the status of the message after sending it
  */

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  /*
    -This function ask for permissions and initiate the process to send messages
  */

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: onBackgroundMessage,
          listenInBackground: true);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: widget.alerte["active"],
        activeColor: d_green,
        onChanged: (bool s) {
          setState(() {
            state = s;
            widget.alerte["active"] = s;
            //print(state);
            if (s == true) {
              initPlatformState();
            }
          });
          changeActive(widget.alerte);
        });
  }

  changeActive(dynamic alerte) async {
    final prefs = await SharedPreferences.getInstance();
    //print(prefs.get(alerte["title"]));
    final keys = prefs.getKeys();
    Iterator<String> it = keys.iterator;
    while (it.moveNext()) {
      if (it.current == widget.alerte["title"]) {
        prefs.remove(it.current);
      }
    }
    String title = alerte["title"];
    String content = alerte["content"];
    final days = alerte["days"];
    final cible = alerte["cibles"];
    final active = state;
    final key = alerte["keys"];
    String tmp =
        '{"title":"$title","content":"$content","days":"$days","cibles":"$cible","active":$active,"keys":$key}';
    prefs.setString(title, tmp);
    //  print(prefs.get(alerte["title"]));
  }
}
/*  
  -That class handles the whole alert screen
*/

// ignore: must_be_immutable
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

  /*
    -Function to delete an alert of the list
  */
  void delete(var alert) async {
    final pref = await SharedPreferences.getInstance();
    Set<String> keys = pref.getKeys();
    Iterator<String> it = keys.iterator;
    // ignore: unused_local_variable
    String cc = "";
    // ignore: unused_local_variable
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

  /*
    - Function that get the number of alerts saved, 0 by default
  */
  void initNb() async {
    final prefs = await SharedPreferences.getInstance();
    int tmp = prefs.getInt("nombreAlerte") ?? -1;
    if (tmp == -1) {
      prefs.setInt("nombreAlerte", 0);
    }
  }

  /*
    -Function that creates a pop up for asking a yes no question
  */
  buildPopupDialog(dynamic alerte) {
    String title = "";
    title = alerte["title"];
    return new AlertDialog(
      title: Text("Voulez vous supprimer $title ?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            setState(() {
              delete(alerte);
              widget.alerts.remove(alerte);
            });
            Navigator.of(context).pop();
          },
          child: const Text('Oui', style: TextStyle(color: Colors.black)),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Non', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Alert createAlert(Alert a, bool actived) {
    Alert res = new Alert(
        title: a.title,
        content: a.content,
        days: a.days,
        cibles: a.cibles,
        keys: a.keys);
    res.active = actived;
    return res;
  }

  /*
    -Function that creates the list of alerts on the screen
  */
  myList(var alerts, int lenght, BuildContext context) {
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
                                alerte: createAlert(
                              new Alert(
                                  title: alerts[index]["title"],
                                  content: alerts[index]["content"],
                                  days: jsonDecode(alerts[index]["days"]),
                                  cibles: jsonDecode(alerts[index]["cibles"]),
                                  keys: buildKeys(alerts[index]["keys"])),
                              alerts[index]["active"],
                            ))),
                  ),
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 106,
                  width: 290,
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
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alerts[index]["title"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'calibri',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      alerts[index]["content"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'calibri',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Row(children: [
                                SwitchButton(
                                  alerte: alerts[index],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            buildPopupDialog(alerts[index])),
                                  },
                                ),
                              ])
                            ],
                          ))
                    ],
                  ),
                ),
              );
            })
        : const Text("Aucune alerte");
  }

  /*
    -Function that creates a loading circle delay for the duration needed
  */
  Future<List> callAsyncFetch() =>
      Future.delayed(Duration(milliseconds: 1), () => widget.alerts);

  /*
    -build the actual page
  */
  @override
  Widget build(BuildContext context) {
    //print("hello");
    for (int i = 0; i < widget.alerts.length; i++) {
      print(widget.alerts[i]);
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
              height: 30,
              child: Row(children: [Text('Mes alertes automatiques')]),
            ),
            FutureBuilder(
                future: callAsyncFetch(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: myList(
                            widget.alerts, widget.alerts.length, context));
                  } else {
                    return CircularProgressIndicator(
                      color: d_green,
                    );
                  }
                }),
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
      ),
    );
  }

  /*
    -Function that show the available aplications to send auto messages with

  */
  void _onButtonPressed() {
    int nb = 0;
    void getNb() async {
      final pref = await SharedPreferences.getInstance();
      //pref.clear();
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
                leading: Icon(
                  Icons.message,
                  color: Colors.blue,
                ),
                title: Text('Messages'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
              _buildDivider(),
              ListTile(
                leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: Text('WhatsApp'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FormScreen(nb: nb)),
                ),
              ),
              _buildDivider(),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebookMessenger,
                    color: Colors.blue),
                title: Text('Messenger'),
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
}

Container _buildDivider() {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1,
      color: Colors.grey.shade400);
}

Future<List> getContents() async {
  final pref = await SharedPreferences.getInstance();
  //pref.clear();
  final tmp = pref.getKeys();
  List contents = <dynamic>[];
  Iterator<String> it = tmp.iterator;
  while (it.moveNext()) {
    if (it.current != "nombreAlerte") {
      contents.add(json.decode(pref.getString(it.current) ?? ""));
    }
  }
  return contents;
}

/*
  This Function gets incomming messages in the back ground
  Check if it contains any of the keys of activated alerts
  Send back the alert message to the person
*/

onBackgroundMessage(SmsMessage message) async {
  List<String> keys = <String>[];
  List contents = <dynamic>[];
  final prefs = await SharedPreferences.getInstance();
  final tmp = prefs.getKeys();
  Iterator<String> it = tmp.iterator;
  while (it.moveNext()) {
    if (it.current != "nombreAlerte") {
      keys.add(it.current);
    }
  }
  contents = await getContents();
  debugPrint("onBackgroundMessage called");
  int i = 0;
  //si le message reçu contient
  while (i < keys.length) {
    if (isActive(
        message.body,
        createAlert(
            new Alert(
                title: contents[i]["title"],
                content: contents[i]["content"],
                days: json.decode(contents[i]["days"]),
                cibles: json.decode(contents[i]["cibles"]),
                keys: buildKeys(contents[i]["keys"])),
            contents[i]["active"]))) {
      Telephony.backgroundInstance.sendSms(
          to: message.address.toString(), message: contents[i]["content"]);
      return;
    }
    i++;
  }
}

String getLastWord(String str) {
  String res = "";
  int i = str.length - 1;
  bool stop = false;
  while (!stop && i >= 0) {
    if (str[i] != " ") {
      res = res + str[i];
      i--;
    } else {
      stop = true;
    }
  }
  String tmp = "";
  // ignore: unused_local_variable
  int j = 0;
  for (int k = res.length - 1; k >= 0; k--) {
    tmp = tmp + res[k];
    j++;
  }
  return tmp;
}

Alert createAlert(Alert a, bool actived) {
  Alert res = new Alert(
      title: a.title,
      content: a.content,
      days: a.days,
      cibles: a.cibles,
      keys: a.keys);
  res.active = actived;
  return res;
}

String getFirstWord(String str) {
  String res = "";
  int i = 0;
  bool stop = false;
  while (!stop && i < str.length) {
    if (str[i] != " ") {
      res = res + str[i];
      i++;
    } else {
      stop = true;
    }
  }
  return res;
}

bool isActive(String? body, Alert alert) {
  if (!alert.active) {
    return false;
  }
  DateTime now = DateTime.now();
  String day = DateFormat('EEEE').format(now);
  if (!dayIsRight(alert, day)) {
    return false;
  }
  // ignore: unused_local_variable
  var where = {
    1: "Contient",
    2: "Ne Contient pas",
    3: "Est au debut",
    4: "Est à la fin"
  };
  for (int i = 0; i < alert.keys.length; i++) {
    if (body!.contains(alert.keys[i].name) &&
        (alert.keys[i].contient == 1) &&
        alert.keys[i].allow) {
      return true;
    } else if (!body.contains(alert.keys[i].name) &&
        (alert.keys[i].contient == 2) &&
        alert.keys[i].allow) {
      return true;
    } else if (getFirstWord(body) == alert.keys[i].name &&
        (alert.keys[i].contient == 3) &&
        alert.keys[i].allow) {
      return true;
    } else if (getLastWord(body) == alert.keys[i].name &&
        (alert.keys[i].contient == 4) &&
        alert.keys[i].allow) {
      return true;
    }
  }
  return false;
}

bool dayIsRight(Alert alert, String day) {
  List<String> weeks = <String>[
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  for (int i = 0; i < weeks.length; i++) {
    if (day == weeks[i] && alert.days[i]) {
      return true;
    }
  }
  return false;
}

List<AlertKey> buildKeys(dynamic input) {
  List<AlertKey> res = <AlertKey>[];

  for (int i = 0; i < input.length; i++) {
    res.add(new AlertKey(
        name: json.decode(input[i])["name"],
        contient: json.decode(input[i])["contient"],
        allow: json.decode(input[i])["allow"] == "true"));
  }

  return res;
}
