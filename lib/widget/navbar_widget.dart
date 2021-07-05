import 'package:flutter/material.dart';
import 'package:mypo/pages/formulaire_alerte_auto_page.dart';
import 'package:mypo/pages/formulaire_alerte_prog_page.dart';
import 'package:mypo/pages/help_page.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/pages/settings_page.dart';
import 'package:mypo/pages/sms_auto_page.dart';
import 'package:mypo/pages/sms_prog_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const d_green = Color(0xFFA6C800);

/*
    -this class is responsible of the bottom nav bar of 2 elements for the sms auto page
*/
// ignore: must_be_immutable
class BottomNavigationBarTwo extends StatelessWidget {
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
          icon: IconButton(
            icon: Icon(
              Icons.schedule_send,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SmsProg()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.sms,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SmsAuto()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.notes_rounded,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomePage()),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}

/*
    -this class is responsible of the bottom nav bar of 3 elements for the sms auto page
*/
// ignore: must_be_immutable
class BottomNavigationBarSmsAuto extends StatelessWidget {
  final String value = 'test';
  int nb = 0;
  void getNb() async {
    final pref = await SharedPreferences.getInstance();
    nb = pref.getInt("nombreAlerte")!;
  }

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
          icon: IconButton(
            icon: Icon(
              Icons.home,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomePage()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new FormScreen(nb: nb)),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}

/*

 -this class is responsible of the bottom nav bar of 3 elements for the schedules mesages page
*/

// ignore: must_be_immutable
class BottomNavigationBarSmsProg extends StatelessWidget {
  final String value = 'test';
  int nb = 0;
  void getNb() async {
    final pref = await SharedPreferences.getInstance();
    nb = pref.getInt("nombreAlerte")!;
  }

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
          icon: IconButton(
            icon: Icon(
              Icons.home,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomePage()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new ProgForm()),
            ),
          ),
          label: '',
        ),
      ],
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
      selectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
              icon: Icon(
                Icons.access_time,
                color: d_green,
                size: 50,
              ),
              onPressed: null),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: d_green,
          icon: IconButton(
            icon: Icon(
              Icons.stacked_bar_chart_rounded,
              color: d_green,
              size: 50,
            ),
            onPressed: null,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: d_green,
          icon: IconButton(
            icon: Icon(
              Icons.help_outline,
              color: d_green,
              size: 50,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new HelpScreen(value: value)),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.settings,
              color: d_green,
              size: 50,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SettingsScreenOne()),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
