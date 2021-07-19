import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/scheduledmsg.dart';
import 'package:mypo/pages/edit_scheduledmsg_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/boxes.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'package:telephony/telephony.dart';
import 'formulaire_alerte_prog_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mypo/model/scheduledmsg_hive.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class SmsProg extends StatefulWidget {
  @override
  _SmsProgState createState() => _SmsProgState();
}

class _SmsProgState extends State<SmsProg> {
  late List<Scheduledmsg> allMessages;
  bool isLoading = false;
  // ignore: unused_field
  Timer? timer;
  String txt = "";
  int i = 0;
  final telephony = Telephony.instance;
  @override
  void initState() {
    super.initState();
    //refreshMessages();
    timer = Timer.periodic(
        Duration(seconds: 20),
        (Timer t) => {
              sendSms(),
            });
  }

  @override
  void dispose() {
    // ScheduledMessagesDataBase.instance.close();
    super.dispose();
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
            Telephony.instance.sendSms(
                to: messages[i].phoneNumber, message: messages[i].message);
            updateDate(messages[i]);
          }
        }
      }
    }
  }

  void updateDate(Scheduledmsg_hive msg) {
    final repeatOptions = [
      'Toutes les heures',
      'Tous les jours',
      'Toutes les semaines',
      'Tous les mois',
      'Tous les ans'
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
    } else {
      msg.date = DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + 365 * 24 * (hour));
    }
    msg.save();
  }

  /**
   * final repeatOptions = [
    'Toutes les heures',
    'Tous les jours',
    'Toutes les semaines',
    'Tous les mois',
    'Tous les ans'
  ];
   */
  bool canbeSent(Scheduledmsg_hive msg) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int msgdate = msg.date.millisecondsSinceEpoch;
    if (now >= msgdate) {
      return true;
    } else {
      return false;
    }
  }

  confirmSend(Scheduledmsg_hive msg) {
    String content = msg.message;
    String to = msg.phoneNumber;
    showDialog(
        context: context,
        builder: (BuildContext dialog) {
          return new AlertDialog(
            title: Text("Voulez envoyer le message $content à $to ?"),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        Telephony.instance.sendSms(to: to, message: content),
                        updateDate(msg),
                        Navigator.of(context).pop(),
                      },
                  child: Text("oui")),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                  child: Text("non"))
            ],
          );
        });
  }

  // SQFLITE
  Future refreshMessages() async {
    setState(() => isLoading = true);
    // this.allMessages =
    //     await ScheduledMessagesDataBase.instance.readAllScheduledmsg();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBar(title: "My Co'Laverie"),
      drawer: HamburgerMenu(),
      body: Scrollbar(
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: 10,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: ValueListenableBuilder<Box<Scheduledmsg_hive>>(
                  valueListenable: Boxes.getScheduledmsg().listenable(),
                  builder: (context, box, _) {
                    final messages =
                        box.values.toList().cast<Scheduledmsg_hive>();

                    return buildListOfMsg(messages);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarSmsProgTwo(),
    );
  }

//HIVE
  Widget buildListOfMsg(List<Scheduledmsg_hive> messages) {
    if (messages.isEmpty) {
      return Center(
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
          OutlinedButton(
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
          SizedBox(height: 20),
          Text(
            'Aucune alerte',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ));
    } else {
      return Column(
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
          SizedBox(height: 20),
          OutlinedButton(
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];

                return buildMsg(context, message);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMsg(BuildContext context, Scheduledmsg_hive message) {
    // ignore: unused_local_variable
    final date = DateFormat.yMMMd().format(message.date);

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
        // trailing: Text(
        //   date,
        //   style: TextStyle(
        //       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        children: [
          buildButtons(context, message),
        ],
      ),
    );
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

  // SQFLITE
  Widget buildMessages() => SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: allMessages.length,
          itemBuilder: (context, index) {
            final msg = allMessages[index];
            return InkWell(
              onTap: () {
                print('index:$index , msgId:${msg.id}');
              },
              child: Container(
                ///////////////////////////
                margin: EdgeInsets.all(20),
                height: 106,
                width: 290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
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
                                  msg.phoneNumber,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'calibri',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    msg.message,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'calibri',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            );
          }));

  //-Function that creates a pop up for asking a yes no question based on a given message
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
            message.delete();
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
