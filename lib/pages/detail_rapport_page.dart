import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/rapports_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/database/hive_database.dart';

class DetailRepportsPage extends StatefulWidget {
  final Rapportmsg_hive message;
  const DetailRepportsPage({Key? key, required this.message}) : super(key: key);

  @override
  _DetailRepportsPageState createState() => _DetailRepportsPageState();
}

class _DetailRepportsPageState extends State<DetailRepportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: d_grey,
        appBar: TopBarRedirection(
            title: "Details de l'alerte ${widget.message.name}",
            page: () => RepportsPage()),
        body: Detail(message: widget.message));
  }
}

class Detail extends StatefulWidget {
  final Rapportmsg_hive message;
  const Detail({Key? key, required this.message}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      isAlwaysShown: true,
      showTrackOnHover: true,
      thickness: 5,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
                        child: Text('Rapport',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Table(
                            children: <TableRow>[
                              TableRow(children: [
                                Text('Type :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('${widget.message.type}')
                              ]),
                              TableRow(children: [
                                Text('Destinataire :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('${widget.message.phoneNumber}')
                              ]),
                              TableRow(children: [
                                Text('Crée le :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '${DateFormat('dd/MM/yyyy').format(widget.message.date)}')
                              ]),
                              TableRow(children: [
                                Text("Heure d'envoi :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '${DateFormat('HH:mm').format(widget.message.date)}')
                              ]),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildLabelText('Message :'),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${widget.message.message}',
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabelText(String input) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 3, 5, 0),
      child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Text(
                input,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              )
            ],
          )),
    );
  }
}
