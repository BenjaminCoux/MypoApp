import 'package:flutter/material.dart';
import 'package:mypo/formulaire_alerte_prog.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/settings.dart';
import 'package:mypo/sms_auto.dart';
import 'package:mypo/test.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class SmsProg extends StatefulWidget {
  @override
  _SmsProgState createState() => _SmsProgState();
}

class _SmsProgState extends State<SmsProg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [Logo(), AlertesProg()],
      )),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}
/*
    -that class creates the logo in the middle
*/

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
          color: d_lightgray,
          image: DecorationImage(image: AssetImage('images/logo.png'))),
    );
  }
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
            FutureBuilder(
                future: null,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Container(
                            /*
                              -List d'alertes

                          */
                            ));
                  } else {
                    return CircularProgressIndicator(
                      color: d_green,
                    );
                  }
                }),
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
