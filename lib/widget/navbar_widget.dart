import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/model/colors.dart';
import 'package:mypo/pages/group_contact._page.dart';
import 'package:mypo/pages/help_page.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/pages/repports_page.dart';
import 'package:mypo/pages/settings_page.dart';
import 'package:path_provider/path_provider.dart';

writeToFile(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/log.txt');
  await file.writeAsString(text);
}

/*
    -this class is responsible of the bottom nav bar of 2 elements for the sms auto page with images as icon
*/
// ignore: must_be_immutable
class BottomNavigationBarSmsAutoTwo extends StatelessWidget {
  /*
    - Building the bottom navigation bar
  */
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: d_green,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/smsauto_activated.png',
            width: 80,
            height: 50,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Accueil",
          icon: IconButton(
              icon: Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()),
                    ),
                  }),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/smsprog_disabled.png',
            width: 80,
            height: 50,
          ),
          label: '',
        ),
      ],
      onTap: (index) {
        //print(index);
        if (index == 0) {}
        if (index == 1) {}
      },
    );
  }
}

/*
    -this class is responsible of the bottom nav bar of 2 elements for the sms prog page with images as icon
*/
// ignore: must_be_immutable
class BottomNavigationBarSmsProgTwo extends StatelessWidget {
  /*
    - Building the bottom navigation bar
  */
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: d_green,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/smsprog_activated.png',
            width: 80,
            height: 50,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Accueil",
          icon: IconButton(
              icon: Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()),
                    ),
                  }),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/smsauto_disabled.png',
            width: 80,
            height: 50,
          ),
          label: '',
        ),
      ],
      onTap: (index) {
        //print(index);
        if (index == 0) {}
        if (index == 1) {}
      },
    );
  }
}

/*
  -This class creates the widget responsible of the bottom navigation bar of 4 elements
*/
class BottomNavigationBarSection extends StatefulWidget {
  @override
  _StateBottomNavigationBarSection createState() =>
      _StateBottomNavigationBarSection();
}

class _StateBottomNavigationBarSection
    extends State<BottomNavigationBarSection> {
  final String value = 'test';

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: d_green,
      selectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          tooltip: "Temps d'accès",
          icon: IconButton(
              icon: Icon(
                Icons.group,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new GroupContactPage())),
                  }),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: 'Rapport',
          icon: IconButton(
              icon: Icon(
                Icons.my_library_books_rounded,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new RepportsPage()),
                    ),
                  }),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: 'Aide',
          icon: IconButton(
              icon: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HelpScreen(value: value)),
                    ),
                  }),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: 'Paramètres',
          icon: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                try {
                  writeToFile("test");
                } catch (e) {
                  debugPrint(e.toString());
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SettingsScreenOne()),
                );
              }),
          label: '',
        ),
      ],
    );
  }
}
