import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/edit_alerte_auto_page.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'formulaire_alerte_auto_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SmsAuto extends StatefulWidget {
  @override
  _SmsAutoState createState() => _SmsAutoState();
}

class _SmsAutoState extends State<SmsAuto> {
  List<Alert> alerts = <Alert>[];

  Future<void> readAlert() async {
    this.alerts = Boxes.getAutoAlert().values.toList().cast<Alert>();

    this.alerts = alerts;
  }

  @override
  void initState() {
    readAlert();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
          title: "Messages automatiques", page: () => HomePage()),
      body: Scrollbar(
        thickness: 5,
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
  Alert alerte;
  SwitchButton({required this.alerte});
  @override
  _StateSwitchButton createState() => _StateSwitchButton();
}

class _StateSwitchButton extends State<SwitchButton> {
  bool state = false;

  final box = Boxes.getAutoAlert();

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
    -This function reacts to messages on the foreground
    it gets incomming messages 
    Check if it contains any of the keys of activated alerts
    Send back the alert message to the person
  */
  onMessage(SmsMessage message) async {
    List<Alert> alerts = Boxes.getAutoAlert().values.toList().cast<Alert>();
    debugPrint("onMessage called (Foreground)");
    Future<bool> test = isContactInContactList(message);
    int i = 0;
    while (i < alerts[i].keys.length) {
      Alert a = alerts[i];
      bool tmp = isActive(message.body, a, await test);
      bool grp = isInGroup(a, message.address);
      if (tmp && grp) {
        print(tmp);
        Telephony.instance
            .sendSms(to: message.address.toString(), message: a.content);
        if (a.notification) {
          String title = a.title;
          String content = a.content;
          String number = message.address.toString();
          _showNotification("Une reponse de l'alerte $title à été envoyée",
              "La reponse '$content' à été envoyée à $number");
        }
        return;
      }
      i++;
    }
  }

  //This function return the status of the message after sending it

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
    final bool? resultContact = await Permission.contacts.request().isGranted;

    if (result != null && result && resultContact!) {
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
        value: widget.alerte.active,
        activeColor: d_green,
        onChanged: (bool s) {
          setState(() {
            state = s;
            widget.alerte.active = s;
            if (s == true) {
              initPlatformState();
            }
          });
          changeActive(widget.alerte, s);
        });
  }

  /**
   * change the active value of an alert both in the alert list and in the sharedPreferences
   */
  changeActive(Alert alerte, bool s) async {
    alerte.active = s;
    alerte.save();
  }
}
/*  
  -That class handles the whole alert screen
*/

// ignore: must_be_immutable
class Alertes extends StatefulWidget {
  List<Alert> alerts = <Alert>[];
  Alertes({required this.alerts});
  @override
  _AlertesState createState() => new _AlertesState();
}

class _AlertesState extends State<Alertes> {
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  /*
    -Function to delete an alert of the list
  */
  void delete(Alert alert) async {
    alert.delete();
  }

  /*
    - Function that get the number of alerts saved, 0 by default
  */

  /*
    -Function that creates a pop up for asking a yes no question
  */
  buildPopupDialog(Alert alerte) {
    String title = "";
    title = alerte.title;
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

  /**
   * store the duplicated alert in the sharedPreferences
   */
  void addToDB(Alert alert, String title) async {
    Alert tmp = Alert()
      ..title = title
      ..content = alert.content
      ..active = alert.active
      ..keys = alert.keys
      ..cibles = alert.cibles
      ..days = alert.days
      ..groupcontats = alert.groupcontats
      ..notification = alert.notification;
    final box = Boxes.getAutoAlert();
    box.add(tmp);
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
      if (widget.alerts[i].title.contains(title)) {
        count++;
      }
    }
    return title + "-" + count.toString();
  }

  /*
    -Function that creates the list of alerts on the screen
  */
  myList(List<Alert> alerts, int lenght, BuildContext context) {
    return lenght > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: alerts.length,
            itemBuilder: (BuildContext context, int index) {
              final alert = alerts[index];
              return buildMsg(context, alert);
            })
        : const Text("Aucune alerte", style: TextStyle(fontSize: 24));
  }

  Widget buildMsg(BuildContext context, Alert alert) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: Text(
          alert.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          alert.content,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SwitchButton(alerte: alert),
        children: [
          buildButtons(context, alert),
        ],
      ),
    );
  }

  buildButtons(BuildContext context, Alert alert) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Modifier',
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              icon: Icon(Icons.edit, size: 20),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AlertScreen(alerte: alert)),
                ),
              },
            ),
          ),
          //TO-DO : When duplication alerttest-2 the duplicate should be named alerttest-2-1 (or alerttest-2-2 if the number 1 was already on the list, so we don't confuse it)

          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Dupliquer',
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              icon: Icon(Icons.copy, size: 20),
              onPressed: () => {
                setState(() {
                  String title = getNbAlerte(alert.title);
                  Alert a = Alert()
                    ..title = title
                    ..content = alert.content
                    ..active = alert.active
                    ..notification = alert.notification
                    ..keys = alert.keys
                    ..groupcontats = alert.groupcontats
                    ..days = alert.days
                    ..cibles = alert.cibles;
                  addToDB(a, title);
                  widget.alerts =
                      Boxes.getAutoAlert().values.toList().cast<Alert>();
                }),
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Supprimer',
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              icon: Icon(Icons.delete, size: 20),
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
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            // Text(
            //   'Mes alertes automatiques',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //     color: Colors.black,
            //   ),
            // ),
            // SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: d_darkgray,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new FormScreen(nb: 0)),
                        ),
                      },
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
            SizedBox(height: 20),
            FutureBuilder(
                future: callAsyncFetch(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: myList(
                            widget.alerts, widget.alerts.length, context));
                  } else {
                    return CircularProgressIndicator(
                      color: d_green,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  /*
    -Function that show the available aplications to send auto messages with
  */

  //pop menu hidden
  void _onButtonPressed() {
    int nb = 0;

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
                  enabled: false,
                  leading: Icon(FontAwesomeIcons.whatsapp, color: d_darkgray),
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
                enabled: false,
                leading:
                    Icon(FontAwesomeIcons.facebookMessenger, color: d_darkgray),
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

/*
  This Function gets incomming messages in the back ground
  Check if it contains any of the keys of activated alerts
  Send back the alert message to the person
*/

/**
 * return the last word in the message body
 */
String getLastWord(String str) {
  String res = "";
  int i = str.length - 1;
  if (str[i] == "." || str[i] == " ") {
    i = str.length - 2;
  }
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
  Alert res = Alert();
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
bool isActive(String? body, Alert alert, bool isInContact) {
  bool res = false;
  if (!alert.active) {
    return res;
  }
  if (((alert.cibles[3] && !isInContact) || (alert.cibles[1] && isInContact)) &&
      (!alert.cibles[3] || !alert.cibles[1])) {
    return res;
  }
  DateTime now = DateTime.now();
  String day = DateFormat('EEEE').format(now);
  if (!dayIsRight(alert, day)) {
    return res;
  }
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

Future<bool> isContactInContactList(SmsMessage message) async {
  List<Contact> _contacts =
      (await ContactsService.getContacts(withThumbnails: false)).toList();
  for (var i = 0; i < _contacts.length; i++) {
    if (message.address.toString() ==
        _contacts[i]
            .phones
            ?.elementAt(0)
            .value!
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('(', '')
            .replaceAll(')', '')) return true;
  }
  return false;
}

onBackgroundMessage(SmsMessage message) async {
  debugPrint("onMessage called (background)");

  final alerts = await getAlerts();
  Future<bool> test = isContactInContactList(message);
  int i = 0;
  while (i < alerts[i].keys.length) {
    Alert a = alerts[i];
    bool tmp = isActive(message.body, a, await test);
    bool grp = isInGroup(a, message.address);
    if (tmp && grp) {
      print(tmp);
      Telephony.instance
          .sendSms(to: message.address.toString(), message: a.content);
      if (a.notification) {
        String title = a.title;
        String content = a.content;
        String number = message.address.toString();
        _showNotification("Une reponse de l'alerte $title à été envoyée",
            "La reponse '$content' à été envoyée à $number");
      }
      return;
    }
    i++;
  }
}

Future<List<Alert>> getAlerts() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    Hive.registerAdapter(ScheduledmsghiveAdapter());
    Hive.registerAdapter(RapportmsghiveAdapter());
    Hive.registerAdapter(UserhiveAdapter());
    Hive.registerAdapter(GroupContactAdapter());
    Hive.registerAdapter(AlertAdapter());
    Hive.registerAdapter(AlertKeyAdapter());

    // loading the <key,values> pair from the local storage into memory
    await Hive.openBox<Alert>('alert');
    try {
      await Hive.openBox<Scheduledmsg_hive>('scheduledmsg');
      await Hive.openBox<GroupContact>('group');
      await Hive.openBox<User_hive>('user');
      await Hive.openBox<Rapportmsg_hive>('rapportmsg');

      await Hive.openBox<Alert>('alertkey');
    } catch (e) {
      debugPrint(e.toString());
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  final alerts = Hive.box<Alert>('alert').values.toList().cast<Alert>();

  return alerts;
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

Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: 'item x');
}

/***
 * function that transform the keys of an alerte from json to AlertKey object
 * 
 */
List<AlertKey> buildKeys(dynamic input) {
  List<AlertKey> res = <AlertKey>[];

  for (int i = 0; i < input.length; i++) {
    res.add(AlertKey()
      ..name = json.decode(input[i])["name"]
      ..contient = json.decode(input[i])["contient"]
      ..allow = json.decode(input[i])["allow"] == "true");
  }

  return res;
}

bool isInGroup(Alert a, String? adress) {
  if (!a.cibles[4]) {
    return true;
  } else if (a.groupcontats.length > 0) {
    for (int i = 0; i < a.groupcontats.length; i++) {
      for (int j = 0; j < a.groupcontats[i].numbers.length; j++) {
        String tmp = a.groupcontats[i].numbers[j]
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('(', '')
            .replaceAll(')', '');
        if (tmp == adress) {
          return true;
        }
      }
    }
    return false;
  } else {
    return true;
  }
}
