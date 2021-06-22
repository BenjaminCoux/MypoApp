import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class MessageScreen extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessageScreen> {
  // ignore: unused_field
  String _message = "";
  final telephony = Telephony.instance;
  List<SmsConversation> msg = new List<SmsConversation>.empty();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<SmsConversation> messages = await telephony.getConversations(
        filter: ConversationFilter.where(ConversationColumn.MSG_COUNT)
            .equals("4")
            .and(ConversationColumn.THREAD_ID)
            .greaterThan("12"),
        sortOrder: [OrderBy(ConversationColumn.THREAD_ID, sort: Sort.ASC)]);
    msg = messages;
    print(msg);
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("$msg")),
          OutlinedButton(
              onPressed: () async {
                telephony.sendSms(
                    to: "0695475138", message: "may the force be with you");
              },
              child: Text('Send a new message'))
        ],
      ),
    ));
  }
}
