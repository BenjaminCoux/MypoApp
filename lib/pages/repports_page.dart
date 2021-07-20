import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';

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
      body: Rapport(),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
class Rapport extends StatefulWidget {
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10),
          child: Card(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Row(children: [
                          Icon(Icons.access_time_filled, color: d_darkgray),
                          Text(' Date :test'),
                        ]),
                        Row(children: [
                          Icon(Icons.person, color: d_darkgray),
                          Text(' Number :test'),
                        ]),
                        Row(children: [
                          Icon(Icons.notifications, color: d_darkgray),
                          Text(' Alerte :test',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        Row(children: [
                          Icon(Icons.sms_rounded, color: d_darkgray),
                          Text(' Message :test'),
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
                          onPressed: () {}),
                    ],
                  ),
                ),
              )
              // Padding(
              //     padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              //     child: Table(
              //       // defaultColumnWidth: ,
              //       children: <TableRow>[
              //         TableRow(children: [
              //           Icon(Icons.date_range),
              //           Text('Type:',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //         ]),
              //         TableRow(children: [
              //           Icon(Icons.notifications),
              //           Text('To:',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //         ]),
              //       ],
              //     ))
            ],
          )))
    ]);
  }
}
////////////////////////////////////////////////////////////////////////////////

class Detail extends StatefulWidget {
  // demander l'alerte

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
                        // defaultColumnWidth: ,
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
                                  Divider(
                                      color: Color(
                                          0x00000000)), // 0 alpha (invisible)
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
                                          //   _message.status == MessageStatus.PENDING ? Icons.schedule :
                                          // _message.status == MessageStatus.SENT ? Icons.done : Icons.error,
                                          color: Colors.white,
                                          size: 16.0,
                                        )
                                      ])
                                ]))))
              ],
            ))
      ],
    );

    // Padding(
    //     padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    //     child: Table(

    //         // defaultColumnWidth: ,
    //         children: <TableRow>[
    //           TableRow(children: [
    //             Text('Type:', style: TextStyle(fontWeight: FontWeight.bold)),
    //             Text('test'),
    //           ]),
    //           TableRow(children: [
    //             Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
    //             Text('test'),
    //           ]),
    //           TableRow(children: [
    //             Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
    //             Text('test'),
    //           ]),
    //           TableRow(children: [
    //             Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
    //             Text('test'),
    //           ])
    //         ]));
    // // Container(
    //     color: Colors.red,
    //     height: MediaQuery.of(context).size.height * 0.10,
    //     width: MediaQuery.of(context).size.width,
    //     child: ListView(children: <Widget>[
    //       ListTile(title: Text('test'), subtitle: Text('test')),
    //     ]));
  }
}
