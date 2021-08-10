import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/edit_alerte_prog_page.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'package:telephony/telephony.dart';
import 'formulaire_alerte_prog_page.dart';
import 'package:mypo/database/hive_database.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SmsProg extends StatefulWidget {
  @override
  _SmsProgState createState() => _SmsProgState();
}

class _SmsProgState extends State<SmsProg> {
  bool isLoading = false;
  Timer? timer;
  String txt = "";
  int i = 0;
  final telephony = Telephony.instance;
  List<Scheduledmsg_hive> alerts =
      Boxes.getScheduledmsg().values.toList().cast<Scheduledmsg_hive>();
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 20),
        (Timer t) => {
              sendSms(),
            });
  }

  saveMsgToRapport(Scheduledmsg_hive message) {
    final messageToRapport = Rapportmsg_hive()
      ..name = message.name
      ..phoneNumber = message.phoneNumber
      ..message = message.message
      ..type = 'Mesage programmé'
      ..date = DateTime.now();
    final box = Boxes.getRapportmsg();
    box.add(messageToRapport);
  }

  void send(Scheduledmsg_hive msg) async {
    if (msg.groupContact.isEmpty) {
      Telephony.instance.sendSms(to: msg.phoneNumber, message: msg.message);
      if (msg.repeat == 'Aucune récurrence') {
        msg.status = false;
      }
    } else {
      for (int i = 0; i < msg.groupContact.length; i++) {
        for (int j = 0; j < msg.groupContact[i].numbers.length; j++) {
          Telephony.instance.sendSms(
              to: msg.groupContact[i].numbers[j], message: msg.message);
          if (msg.repeat == 'Aucune récurrence') {
            msg.status = false;
          }
        }
      }
    }
  }

  void sendSms() async {
    List<Scheduledmsg_hive> messages =
        Boxes.getScheduledmsg().values.toList().cast<Scheduledmsg_hive>();
    if (!messages.isEmpty) {
      for (int i = 0; i < messages.length; i++) {
        if (canbeSent(messages[i])) {
          if (messages[i].confirm) {
            confirmSend(messages[i]);
          } else {
            send(messages[i]);
            saveMsgToRapport(messages[i]);

            updateDate(messages[i]);
            if (messages[i].notification) {
              _showNotification(messages[i].phoneNumber,
                  messages[i].groupContact, messages[i].message);
            }
          }
        } else if (fiveMinutesBeforeSend(messages[i]) &&
            messages[i].countdown) {
          String nom = messages[i].name;
          _showNotificationBis(
              "5 minutes avant l'envoie de l'alerte $nom", "accedez à l'appli");
          messages[i].countdown = false;
        }
      }
    }
  }

  bool fiveMinutesBeforeSend(Scheduledmsg_hive msg) {
    int five_minutes = 300000;
    if (DateTime.now().millisecondsSinceEpoch + five_minutes >=
        msg.date.millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }

  void updateDate(Scheduledmsg_hive msg) {
    final repeatOptions = [
      'Toutes les heures',
      'Tous les jours',
      'Toutes les semaines',
      'Tous les mois',
      'Tous les ans',
      'Aucune récurrence'
    ];
    int hour = 3600000;
    if (msg.repeat == repeatOptions[0]) {
      msg.date = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + hour);
    } else if (msg.repeat == repeatOptions[1]) {
      msg.date = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + 24 * (hour));
    } else if (msg.repeat == repeatOptions[2]) {
      msg.date = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + 168 * hour);
    } else if (msg.repeat == repeatOptions[3]) {
      msg.date = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + 30 * 24 * hour);
    } else if (msg.repeat == repeatOptions[4]) {
      msg.date = DateTime(msg.date.year + 1, msg.date.month, msg.date.day,
          msg.date.hour, msg.date.minute);
    } else {}
    msg.save();
  }

  bool canbeSent(Scheduledmsg_hive msg) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int msgdate = msg.date.millisecondsSinceEpoch;
    if (now >= msgdate && msg.status == true) {
      return true;
    } else {
      return false;
    }
  }

  Future selectNotification(String payload) async {
    // ignore: unnecessary_null_comparison
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> _showNotification(
      String number, List<GroupContact> list, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (list == null || list.isEmpty) {
      await flutterLocalNotificationsPlugin.show(
          0,
          'Le message suivant à été envoyé à $number',
          body,
          platformChannelSpecifics,
          payload: 'item x');
    } else {
      String tmp = "";
      for (int i = 0; i < list.length; i++) {
        tmp += list[i].name + " ";
      }
      await flutterLocalNotificationsPlugin.show(
          0,
          'Le message suivant à été envoyé à $tmp',
          body,
          platformChannelSpecifics,
          payload: 'item x');
    }
  }

  Future<void> _showNotificationBis(String title, String body) async {
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

  confirmSend(Scheduledmsg_hive msg) {
    timer!.cancel();
    bool notif = msg.notification;
    int five_min = 300000 * 6;
    String content = msg.message;
    String grp_name = "";
    for (int i = 0; i < msg.groupContact.length; i++) {
      if (i != msg.groupContact.length - 1) {
        grp_name += msg.groupContact[i].name + ",";
      } else {
        grp_name += msg.groupContact[i].name;
      }
    }
    String to = msg.phoneNumber.length == 0 ? msg.phoneNumber : grp_name;
    showDialog(
        context: context,
        builder: (BuildContext dialog) {
          return new AlertDialog(
            title: Text("Voulez-vous envoyer le message $content à $to ?"),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        updateDate(msg),
                        if (notif)
                          {
                            _showNotification(
                                msg.phoneNumber, msg.groupContact, msg.message),
                          },
                        this.timer = Timer.periodic(
                            Duration(seconds: 20),
                            (Timer t) => {
                                  sendSms(),
                                }),
                        Navigator.of(context).pop(),
                      },
                  child: Text("oui")),
              TextButton(
                  onPressed: () => {
                        msg.date = new DateTime.fromMillisecondsSinceEpoch(
                            DateTime.now().millisecondsSinceEpoch + five_min),
                        msg.save(),
                        this.timer = Timer.periodic(
                            Duration(seconds: 20),
                            (Timer t) => {
                                  sendSms(),
                                }),
                        Navigator.of(context).pop(),
                      },
                  child: Text("non"))
            ],
          );
        });
  }

  myList(List<Scheduledmsg_hive> alerts, int lenght, BuildContext context) {
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

  /*
    -Function that creates a loading circle delay for the duration needed
  */
  Future<List> callAsyncFetch() =>
      Future.delayed(Duration(milliseconds: 1), () => alerts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
          title: "Messages programmés", page: () => HomePage()),
      body: Scrollbar(
        thickness: 5,
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Mes alertes programmées',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: d_darkgray,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () => {
                                  Navigator.pop(context),
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new ProgForm()))
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
                                  child:
                                      myList(alerts, alerts.length, context));
                            } else {
                              return CircularProgressIndicator(
                                color: d_green,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarSmsProgTwo(),
    );
  }

  Widget buildMsg(BuildContext context, Scheduledmsg_hive message) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: Text(
          message.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          message.message,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          buildButtons(context, message),
        ],
      ),
    );
  }

  void addToDB(Scheduledmsg_hive alert, String title) async {
    Scheduledmsg_hive msg = Scheduledmsg_hive()
      ..name = alert.name
      ..confirm = alert.confirm
      ..countdown = alert.countdown
      ..date = alert.date
      ..dateOfCreation = alert.dateOfCreation
      ..message = alert.message
      ..groupContact = alert.groupContact
      ..phoneNumber = alert.phoneNumber
      ..notification = alert.notification
      ..repeat = alert.repeat;
    final box = Boxes.getScheduledmsg();
    box.add(msg);
  }

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
    for (int i = 0; i < alerts.length; i++) {
      if (alerts[i].name.contains(title)) {
        count++;
      }
    }
    return title + "-" + count.toString();
  }

  buildButtons(BuildContext context, Scheduledmsg_hive message) => Row(
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
                    builder: (context) =>
                        ScheduledmsgDetailPage(message: message),
                  ),
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
                  String title = getNbAlerte(message.name);
                  Scheduledmsg_hive msg = Scheduledmsg_hive()
                    ..name = title
                    ..confirm = message.confirm
                    ..countdown = message.countdown
                    ..date = message.date
                    ..dateOfCreation = message.dateOfCreation
                    ..message = message.message
                    ..groupContact = message.groupContact
                    ..phoneNumber = message.phoneNumber
                    ..notification = message.notification
                    ..repeat = message.repeat;

                  addToDB(msg, title);
                  alerts = Boxes.getScheduledmsg()
                      .values
                      .toList()
                      .cast<Scheduledmsg_hive>();
                }),
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Supprimer'),
              icon: Icon(Icons.delete),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        buildPopupDialog(message)),
              },
            ),
          ),
        ],
      );

  buildPopupDialog(Scheduledmsg_hive message) {
    String title = "";
    title = message.name;
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
              message.delete();
              alerts.remove(message);
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
}
