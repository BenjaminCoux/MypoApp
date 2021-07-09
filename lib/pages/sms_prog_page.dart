import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypo/database/scheduledmsg_database.dart';
import 'package:mypo/model/scheduledmsg.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/boxes.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'formulaire_alerte_prog_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mypo/model/scheduledmsg_hive.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class SmsProg extends StatefulWidget {
  @override
  _SmsProgState createState() => _SmsProgState();
}

class _SmsProgState extends State<SmsProg> {
  late List<Scheduledmsg> allMessages;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMessages();
  }

  @override
  void dispose() {
    // ScheduledMessagesDataBase.instance.close();
    super.dispose();
  }

  Future refreshMessages() async {
    setState(() => isLoading = true);
    this.allMessages =
        await ScheduledMessagesDataBase.instance.readAllScheduledmsg();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: "My Co'Laverie"),
      drawer: HamburgerMenu(),
      body: ValueListenableBuilder<Box<Scheduledmsg_hive>>(
        valueListenable: Boxes.getScheduledmsg().listenable(),
        builder: (context, box, _) {
          final messages = box.values.toList().cast<Scheduledmsg_hive>();

          return buildListOfMsg(messages);
        },
      ),
      bottomNavigationBar: BottomNavigationBarSmsProgTwo(),
    );
  }

//HIVE
  Widget buildListOfMsg(List<Scheduledmsg_hive> messages) {
    if (messages.isEmpty) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Mes alertes programmées',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No messages yet!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: d_darkgray,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProgForm()))
                  },
              child: Text(
                "+ Ajouter une alerte",
                style: TextStyle(
                    backgroundColor: d_darkgray,
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white,
                    fontFamily: 'calibri'),
              )),
        ],
      ));
    } else {
      return Scrollbar(
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: 15,
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'Mes alertes programmées',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = messages[index];

                  return buildMsg(context, message);
                },
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: d_darkgray,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ProgForm()))
                    },
                child: Text(
                  "+ Ajouter une alerte",
                  style: TextStyle(
                      backgroundColor: d_darkgray,
                      fontSize: 16,
                      letterSpacing: 2.2,
                      color: Colors.white,
                      fontFamily: 'calibri'),
                )),
          ],
        ),
      );
    }
  }

  Widget buildMsg(BuildContext context, Scheduledmsg_hive message) {
    // ignore: unused_local_variable
    final date = DateFormat.yMMMd().format(message.date);

    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          message.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(message.message),
        // trailing: Text(
        //   date,
        //   style: TextStyle(
        //       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        children: [
          buildButtons(context, message),
        ],
      ),
    );
  }

  buildButtons(BuildContext context, Scheduledmsg_hive message) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
                style: TextButton.styleFrom(primary: d_darkgray),
                label: Text('Edit'),
                icon: Icon(Icons.edit),
                onPressed: () {}),
          ),
          Expanded(
            child: TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.red.shade400),
                label: Text('Delete'),
                icon: Icon(Icons.delete),
                onPressed: () {}),
          ),
          Expanded(
            child: TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.red.shade400),
                label: Text('Delete'),
                icon: Icon(Icons.delete),
                onPressed: () {}),
          )
        ],
      );

  // SQFLITE
  Widget buildMessages() => SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: allMessages.length,
          itemBuilder: (context, index) {
            final msg = allMessages[index];
            return InkWell(
              onTap: () {
                print('index:$index , msgId:${msg.id}');
              },
              child: Container(
                ///////////////////////////
                margin: EdgeInsets.all(20),
                height: 106,
                width: 290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.phoneNumber,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'calibri',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    msg.message,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'calibri',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            );
          }));
}

class AlertesProg extends StatefulWidget {
  @override
  _AlertesProgState createState() => new _AlertesProgState();
}

class _AlertesProgState extends State<AlertesProg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
              height: 30,
              child: Row(children: [Text('Mes Alertes Programmées')]),
            ),

            // FutureBuilder(
            //     future: null,
            //     builder: (context, AsyncSnapshot<dynamic> snapshot) {
            //       if (snapshot.hasData) {
            //         return Container(
            //             margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            //             child: Container(
            //                 /*
            //                   -List d'alertes

            //               */
            //                 ));
            //       } else {
            //         return Text('Aucune alerte');
            //       }
            //     }),
            SizedBox(height: 50),
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: d_darkgray,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ProgForm()))
                      },
                  child: Text(
                    "+ Ajouter une alerte",
                    style: TextStyle(
                        backgroundColor: d_darkgray,
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.white,
                        fontFamily: 'calibri'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
