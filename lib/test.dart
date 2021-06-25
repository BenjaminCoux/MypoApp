import 'package:flutter/material.dart';
import 'package:mypo/helppage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) async {
  final pref = await SharedPreferences.getInstance();
  Set<String> keys = pref.getKeys();

  Iterator<String> it = keys.iterator;

  bool done = false;
  while (it.moveNext() && !done) {
    if (it.current != "nombreAlerte") {
      print(it.current);

      String clef = "WIFI";
      clef = it.current;
      String contenu = "Voici le mdp : 0000";
      String? test = pref.getString(it.current);
      print(test);

      debugPrint("onBackgroundMessage called");

      //si le message reçu contient
      if (message.body!.contains(clef)) {
        print(message.address.toString() +
            " : ce numero contient la clef (" +
            clef +
            ") , nous avons envoyer le message suivant [" +
            contenu +
            "]");
        Telephony.backgroundInstance
            .sendSms(to: message.address.toString(), message: contenu);
      }
    }
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String value = 'teteet';

  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    String contenu = " Message de test ";
    setState(() {
      _message = message.body ?? "Error reading message body.";
      print("vous avez reçu une nouvelle message");
      Telephony.instance
          .sendSms(to: message.address.toString(), message: contenu);
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

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

  ReponseWifi(String clef, String contenu) async {
    List<SmsMessage> messages = await telephony.getInboxSms();

    for (SmsMessage msg in messages) {
      //debugPrint(msg.body.toString());
      if (msg.body!.contains(clef)) {
        print(msg.address.toString() +
            " : ce numero contient la clef (" +
            clef +
            ") , nous avons envoyer le message suivant [" +
            contenu +
            "]");
        if (msg.address != null) {
          await telephony.sendSms(to: msg.address.toString(), message: contenu);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'screen test',
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  value = text;
                },
              ),
              ElevatedButton(
                onPressed: () => {initPlatformState()},
                child: Text("Test"),
              )
            ]));
  }
}
