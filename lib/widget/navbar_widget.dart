import 'package:flutter/material.dart';
import 'package:mypo/pages/formulaire_alerte_auto_page.dart';
import 'package:mypo/pages/formulaire_alerte_prog_page.dart';
import 'package:mypo/pages/help_page.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const d_green = Color(0xFFA6C800);

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
    -this class is responsible of the bottom nav bar of 2 elements for the sms auto page
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
      type: BottomNavigationBarType.fixed,
      backgroundColor: d_green,
      selectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          tooltip: 'test',
          icon: IconButton(
              icon: Icon(
                Icons.access_time,
                color: Colors.white,
                size: 50,
              ),
              onPressed: null),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.my_library_books_rounded,
              color: Colors.white,
              size: 50,
            ),
            onPressed: null,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
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
              Icons.settings_outlined,
              color: Colors.white,
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
