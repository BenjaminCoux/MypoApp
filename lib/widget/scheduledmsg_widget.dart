import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/main.dart';
import 'package:mypo/model/scheduledmsg.dart';

class ScheduledMessageWidget extends StatelessWidget {
  final Scheduledmsg message;
  final int index;

  ScheduledMessageWidget({
    Key? key,
    required this.message,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().format(message.date);
    return Card(
      color: d_lightgray,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.phoneNumber,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(message.message,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(time,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
