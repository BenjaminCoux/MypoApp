import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/colors.dart';
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
        backgroundColor: Colors.grey.shade100,
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
                            Text('Type :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${widget.message.type}')
                          ]),
                          TableRow(children: [
                            Text('Destinataire :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${widget.message.phoneNumber}')
                          ]),
                          TableRow(children: [
                            Text('Crée le :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '${DateFormat('dd/MM/yyyy').format(widget.message.date)}')
                          ]),
                          TableRow(children: [
                            Text("Heure d'envoi :",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '${DateFormat('HH:mm').format(widget.message.date)}')
                          ]),
                          TableRow(children: [
                            Text('Message :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${widget.message.message}')
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
                Icon(Icons.person, size: 35.0, color: Colors.grey.shade900),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Card(
                        color: d_green,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${widget.message.message}',
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 16.9, color: Colors.white),
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
                                          'envoyé',
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.check,
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
