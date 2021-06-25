import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

/*
  This Function gets incomming messages in the back ground
  Check if it contains any of the keys of activated alerts
  Send back the alert message to the person
*/

onBackgroundMessage(SmsMessage message) async {
  final pref = await SharedPreferences.getInstance();
  Set<String> keys = pref.getKeys();

  Iterator<String> it = keys.iterator;

  bool done = false;
  // go through all the alerts and check if the message contains any of the keys
  // if yes send back message with current alert message
  // if no do nothing
  while (it.moveNext() && !done) {
    if (it.current != "nombreAlerte") {
      // ignore: todo
      //TODO
      print(it.current);
    }
  }
  String clef = "WIFI";
  String contenu = "Message de test (ON BACKGROUND)";

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

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String value = 'teteet';

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
    it gets incomming messages in the back ground
    Check if it contains any of the keys of activated alerts
    Send back the alert message to the person
  */
  onMessage(SmsMessage message) async {
    String contenu = " Message de test (ON MESSAGE)";
    setState(() {
      _message = message.body ?? "Error reading message body.";
      print("vous avez reçu une nouvelle message");
      Telephony.instance
          .sendSms(to: message.address.toString(), message: contenu);
    });
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
