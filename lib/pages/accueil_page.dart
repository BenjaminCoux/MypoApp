import 'package:flutter/material.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/utils/couleurs.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/widget/logo_widget.dart';
import 'package:mypo/widget/navbar_widget.dart';
import 'sms_auto_page.dart';
import 'sms_prog_page.dart';

// **************************************************************************
// This class creates the home page screen
// input :
// output : scaffold widget with the components/widgets of home page
// **************************************************************************

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool userDefined = false;
    User_hive? user;
    List users = Boxes.getUser().values.toList().cast<User_hive>();
    if (!users.isEmpty) {
      userDefined = true;

      user = users[0];
    }

    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBar(title: userDefined ? user!.name : "My'Po"),
      drawer: HamburgerMenu(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Logo(imgPath: userDefined ? user!.imagePath : null), Mode()],
      )),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}

// **************************************************************************
// That class creates icons to navigate to : programmed-msg or auto-message
// input :
// output : column widget with the buttons to navigate to different pages
// **************************************************************************

class Mode extends StatefulWidget {
  @override
  _ModeState createState() => new _ModeState();
}

class _ModeState extends State<Mode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new SmsProg()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Colors.white,
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/smsprog.png'))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Message \nProgrammé',
                        style: TextStyle(
                          fontFamily: 'calibri',
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new SmsAuto()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Colors.white,
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/smsauto.png'))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Message \nAutomatique',
                        style: TextStyle(
                          fontFamily: 'calibri',
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
