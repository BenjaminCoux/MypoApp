import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/database/scheduledmsg_database.dart';
import 'package:mypo/model/scheduledmsg.dart';
import 'package:mypo/widget/appbar_widget.dart';

class ScheduledmsgDetailPage extends StatefulWidget {
  final int messageId;

  const ScheduledmsgDetailPage({
    Key? key,
    required this.messageId,
  }) : super(key: key);

  @override
  _ScheduledmsgDetailPageState createState() => _ScheduledmsgDetailPageState();
}

class _ScheduledmsgDetailPageState extends State<ScheduledmsgDetailPage> {
  late Scheduledmsg msg;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshMessages();
  }

  Future refreshMessages() async {
    setState(() => isLoading = true);
    this.msg = await ScheduledMessagesDataBase.instance
        .readScheduledmsg(widget.messageId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: TopBar(
        title: 'Message detail',
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    msg.phoneNumber,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(DateFormat.yMMMd().format(msg.date),
                      style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    msg.message,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ));
}
