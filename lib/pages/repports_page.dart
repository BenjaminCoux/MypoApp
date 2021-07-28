import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/boxes.dart';
import 'package:mypo/database/scheduledmsg_hive.dart';

import '../main.dart';

class RepportsPage extends StatefulWidget {
  @override
  _RepportsPageState createState() => _RepportsPageState();
}

class _RepportsPageState extends State<RepportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBar(title: "Rapport des alertes émises"),
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
                  child: ValueListenableBuilder<Box<Rapportmsg_hive>>(
                    valueListenable: Boxes.getRapportmsg().listenable(),
                    builder: (context, box, _) {
                      final rapportmsg =
                          box.values.toList().cast<Rapportmsg_hive>();
                      return Rapport(rapportmsg: rapportmsg);
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// ignore: must_be_immutable
class Rapport extends StatefulWidget {
  List rapportmsg;

  Rapport({required this.rapportmsg});
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  @override
  Widget build(BuildContext context) {
    if (widget.rapportmsg.isEmpty) {
      return Center(
        child: Text(
          'Aucun message',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.rapportmsg.length,
        itemBuilder: (BuildContext context, int index) {
          final message = widget.rapportmsg[index];

          return buildMessage(context, message);
        },
      );
    }
  }

  Widget buildMessage(BuildContext context, Rapportmsg_hive message) {
    late String preview = " ";
    for (int i = 0; i < message.message.length && i < 20; i++) {
      preview += message.message[i];
    }
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.67,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Row(children: [
                        Icon(Icons.access_time_filled, color: d_darkgray),
                        Text(
                            ' Date: ${DateFormat('dd/MM/yyyy HH:mm').format(message.date)}'),
                      ]),
                      Row(children: [
                        Icon(Icons.person, color: d_darkgray),
                        Text(' Numéro: ${message.phoneNumber}'),
                      ]),
                      Row(children: [
                        Icon(Icons.notifications, color: d_darkgray),
                        Text(' Alerte: ${message.name}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        Icon(Icons.sms_rounded, color: d_darkgray),
                        message.message.length < 20
                            ? Text(' Message: ${message.message}',
                                overflow: TextOverflow.ellipsis)
                            : Text(' Message: ${preview}...',
                                overflow: TextOverflow.ellipsis),
                      ]),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 5),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 35,
                      color: d_green,
                    ),
                    SizedBox(height: 5),
                    IconButton(
                        padding: EdgeInsets.all(12),
                        icon: Icon(Icons.delete, color: Colors.black, size: 35),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  buildPopupDialog(message));
                        }),
                  ],
                ),
              ),
            )
          ],
        )));
  }

  buildPopupDialog(Rapportmsg_hive message) {
    String title = "";
    title = message.name;
    return new AlertDialog(
      title: Text("Voulez vous SUPPRIMER $title ?"),
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

////////////////////////////////////////////////////////////////////////////////

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
                    child: Text('Message Details',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: Table(
                        children: <TableRow>[
                          TableRow(children: [
                            Text('Type:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                          TableRow(children: [
                            Text('To:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                          TableRow(children: [
                            Text('Created:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                          TableRow(children: [
                            Text('Scheduled:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                          TableRow(children: [
                            Text('Attempts:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                          TableRow(children: [
                            Text('Status:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('test')
                          ]),
                        ],
                      ))
                ]),
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(left: 25.0, right: 20.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.person, size: 35.0, color: Colors.deepOrange),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Card(
                        color: Colors.brown,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'test',
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 16.9,
                                        color: Color(0xFFFFFFFF)),
                                    textAlign: TextAlign.left,
                                  ),
                                  Divider(color: Colors.transparent),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          'test',
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              color: Color(0xDDFDFDFD),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.schedule,
                                          color: Colors.white,
                                          size: 16.0,
                                        )
                                      ])
                                ]))))
              ],
            ))
      ],
    );
  }
}
