import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypo/model/alert.dart';
import 'package:mypo/model/alertkey.dart';
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
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: "My Co'Laverie"),
      drawer: HamburgerMenu(),
      body: Scrollbar(
        thickness: 10,
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

  /**
   * change the active value of an alert both in the alert list and in the sharedPreferences
   */
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
    List<dynamic> tmpK = <dynamic>[];
    for (int i = 0; i < key.length; i++) {
      tmpK.add(json.decode(key[i]));
    }
    List<AlertKey> keyList = <AlertKey>[];
    for (int i = 0; i < tmpK.length; i++) {
      keyList.add(new AlertKey(
          name: tmpK[i]["name"],
          contient: tmpK[i]["contient"],
          allow: tmpK[i]["allow"] == "true"));
    }
    List<String> listK = <String>[];
    for (int i = 0; i < keyList.length; i++) {
      listK.add(keyList[i].toString());
    }
    String kstr = json.encode(listK);
    String tmp =
        '{"title":"$title","content":"$content","days":"$days","cibles":"$cible","active":$active,"keys":$kstr}';
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

  /**
   * store the duplicated alert in the sharedPreferences
   */
  void addToDB(dynamic alert, String title) async {
    final prefs = await SharedPreferences.getInstance();
    String content = alert["content"];
    final days = alert["days"];
    final cibles = alert["cibles"];
    final active = alert["active"];
    List<AlertKey> keys = buildKeys(alert["keys"]);
    List<String> aStr = <String>[];
    for (int i = 0; i < keys.length; i++) {
      aStr.add(keys[i].toString());
    }
    String str = json.encode(aStr);
    String tmp =
        '{"title":"$title","content":"$content","days":"$days","cibles":"$cibles","active":$active,"keys":$str}';
    prefs.setString(title, tmp);
  }

  /**
   * fucntion that return a title for the alert duplication
   */
  String getNbAlerte(String title) {
    if (title.contains("-")) {
      String tmp = "";
      bool stop = false;
      int i = 0;
      while (!stop && i < title.length) {
        if (title[i] == "-") {
          stop = true;
        } else {
          tmp = tmp + title[i];
        }
        i++;
      }
      title = tmp;
    }
    int count = 0;
    for (int i = 0; i < widget.alerts.length; i++) {
      if (widget.alerts[i]["title"].contains(title)) {
        count++;
      }
    }
    return title + "-" + count.toString();
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
              final alert = alerts[index];
              return buildMsg(context, alert);
            })
        : const Text("Aucune alerte", style: TextStyle(fontSize: 24));
  }

  Widget buildMsg(BuildContext context, var alert) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: Text(
          alert["title"],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          alert["content"],
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SwitchButton(alerte: alert),
        children: [
          buildButtons(context, alert),
        ],
      ),
    );
  }

  buildButtons(BuildContext context, var alert) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Modifier'),
              icon: Icon(Icons.edit),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AlertScreen(
                              alerte: createAlert(
                            new Alert(
                                title: alert["title"],
                                content: alert["content"],
                                days: jsonDecode(alert["days"]),
                                cibles: jsonDecode(alert["cibles"]),
                                keys: buildKeys(alert["keys"])),
                            alert["active"],
                          ))),
                ),
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Dupliquer'),
              icon: Icon(Icons.copy),
              onPressed: () => {
                setState(() {
                  String title = getNbAlerte(alert["title"]);
                  widget.alerts.add({
                    "title": title,
                    "content": alert["content"],
                    "days": alert["days"],
                    "cibles": alert["cibles"],
                    "active": alert["active"],
                    "keys": alert["keys"]
                  });
                  addToDB(alert, title);
                }),
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.red.shade400),
              label: Text('Supprimer'),
              icon: Icon(Icons.delete),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildPopupDialog(alert)),
              },
            ),
          )
        ],
      );

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
    // for (int i = 0; i < widget.alerts.length; i++) {
    //   print(widget.alerts[i]);
    // }
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'Mes alertes automatiques',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
                future: callAsyncFetch(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        // margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: myList(
                            widget.alerts, widget.alerts.length, context));
                  } else {
                    return CircularProgressIndicator(
                      color: d_green,
                    );
                  }
                }),
            SizedBox(height: 20),
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
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new FormScreen(nb: nb)),
                        ),
                      }),
              _buildDivider(),
              ListTile(
                  leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  title: Text('WhatsApp'),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new FormScreen(nb: nb)),
                        ),
                      }),
              _buildDivider(),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebookMessenger,
                    color: Colors.blue),
                title: Text('Messenger'),
                onTap: () => {
                  Navigator.pop(context),
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new FormScreen(nb: nb)),
                  ),
                },
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
      Telephony.backgroundInstance
          .sendSms(to: '', message: contents[i]["content"]);
      return;
    }
    i++;
  }
}

/**
 * return the last word in the message body
 */
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

/**
 * return an alerte from an original alert and the activated value
 */
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

/**
 * return the first word in the message body
 */
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

/**
 * function that check if an alert should respond to a received message on the phone
 */
bool isActive(String? body, Alert alert) {
  bool res = false;
  if (!alert.active) {
    return res;
  }
  DateTime now = DateTime.now();
  String day = DateFormat('EEEE').format(now);
  if (!dayIsRight(alert, day)) {
    return res;
  }
  // ignore: unused_local_variable
  var where = {
    1: "Contient",
    2: "Ne Contient pas",
    3: "Est au debut",
    4: "Est à la fin"
  };
  for (int i = 0; i < alert.keys.length; i++) {
    if (dontAllow(body, alert)) {
      return false;
    } else if (body!.contains(alert.keys[i].name) &&
        (alert.keys[i].contient == 1) &&
        alert.keys[i].allow) {
      res = true;
    } else if (!body.contains(alert.keys[i].name) &&
        (alert.keys[i].contient == 2) &&
        alert.keys[i].allow) {
      res = true;
    } else if (getFirstWord(body) == alert.keys[i].name &&
        (alert.keys[i].contient == 3) &&
        alert.keys[i].allow) {
      res = true;
    } else if (getLastWord(body) == alert.keys[i].name &&
        (alert.keys[i].contient == 4) &&
        alert.keys[i].allow) {
      res = true;
    }
  }
  return res;
}

/**
 * function that check if a not allowed word is present in the body of the message
 */
bool dontAllow(String? body, Alert a) {
  for (int i = 0; i < a.keys.length; i++) {
    if (body!.contains(a.keys[i].name) &&
        a.keys[i].contient == 1 &&
        !a.keys[i].allow) {
      return true;
    } else if (!body.contains(a.keys[i].name) &&
        a.keys[i].contient == 2 &&
        !a.keys[i].allow) {
      return true;
    } else if (getFirstWord(body) == a.keys[i].name &&
        a.keys[i].contient == 3 &&
        !a.keys[i].allow) {
      return true;
    } else if (getLastWord(body) == a.keys[i].name &&
        a.keys[i].contient == 4 &&
        !a.keys[i].allow) {
      return false;
    }
  }
  return false;
}

bool dayIsRight(Alert alert, String day) {
  List<String> weeks = <String>[
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  for (int i = 0; i < weeks.length; i++) {
    if (day == weeks[i] && alert.days[i]) {
      return true;
    }
  }
  return false;
}

/***
 * function that transform the keys of an alerte from json to AlertKey object
 * 
 */
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
