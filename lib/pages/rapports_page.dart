import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/detail_rapport_page.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/database/hive_database.dart';

class RepportsPage extends StatefulWidget {
  @override
  _RepportsPageState createState() => _RepportsPageState();
}

class _RepportsPageState extends State<RepportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
          title: "Rapport des alertes émises", page: () => HomePage()),
      body: Scrollbar(
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: 5,
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
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemCount: widget.rapportmsg.length,
        itemBuilder: (BuildContext context, int index) {
          final message =
              widget.rapportmsg[widget.rapportmsg.length - 1 - index];

          return buildMessage(context, message);
        },
      );
    }
  }

  preview(String text) {
    String preview = '';
    for (int i = 0; i < text.length && i < 12; i++) {
      preview += text[i];
    }

    return preview;
  }

  Widget buildMessage(BuildContext context, Rapportmsg_hive message) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () => {
            Navigator.pop(context),
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => DetailRepportsPage(message: message),
              ),
            ),
          },
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
                      padding: EdgeInsets.all(8),
                      child: Column(children: [
                        Row(children: [
                          Icon(Icons.access_time_filled, color: d_darkgray),
                          Text(
                              ' Date: ${DateFormat('dd/MM/yyyy HH:mm').format(message.date)}'),
                        ]),
                        Row(children: [
                          Icon(Icons.person, color: d_darkgray),
                          message.phoneNumber.length < 20
                              ? Text(' Numéro: ${message.phoneNumber}',
                                  overflow: TextOverflow.ellipsis)
                              : Text(
                                  ' Numéro: ${preview(message.phoneNumber)}...',
                                  overflow: TextOverflow.ellipsis),
                          // Text(' Numéro: ${message.phoneNumber}'),
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
                              : Text(' Message: ${preview(message.message)}...',
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
                          icon:
                              Icon(Icons.delete, color: Colors.black, size: 35),
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
          )),
        ));
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

