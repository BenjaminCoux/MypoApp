import 'package:flutter/material.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/settings.dart';
import 'package:mypo/sms_auto.dart';
import 'package:mypo/sms_prog.dart';
import 'package:mypo/test.dart';

/*
  -colors used in the app
*/

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

/*
  -That class creates the home page
*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [Logo(), Mode()],
      )),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}
/*
  -that class creates the top app bad widget
*/

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text('My Co\'Laverie', style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
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

/*
    -That class creates icons to navigate to : programmed-msg or auto-message

*/
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
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new SmsProg()),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    margin: EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('images/smsprog.png'))),
                    child: Text(
                      'Messages programmés',
                      style: TextStyle(fontFamily: 'calibri'),
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new SmsAuto()),
                ),
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('images/smsauto.png'))),
                    child: Text(
                      'Messages automatiques',
                      style: TextStyle(fontFamily: 'calibri'),
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: d_green,
            padding: EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new TestPage()));
          },
          child: Text(
            "Test msg auto",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2.2,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/*
  -This class creates the widget responsible of the bottom navigation bar
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
