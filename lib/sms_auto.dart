import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/homepage.dart';
import 'package:mypo/alerte.dart';
import 'package:mypo/menu_item.dart';
import 'package:mypo/menu_items.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

class SmsAuto extends StatefulWidget {
  @override
  _SmsAutoState createState() => _SmsAutoState();
}

class _SmsAutoState extends State<SmsAuto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [Logo(), Alertes()],
      )),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}

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

class SwitchButton extends StatefulWidget {
  @override
  _StateSwitchButton createState() => _StateSwitchButton();
}

class _StateSwitchButton extends State<SwitchButton> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: state,
        activeColor: d_green,
        onChanged: (bool s) {
          setState(() {
            state = s;
            print(state);
          });
        });
  }
}

class Alertes extends StatefulWidget {
  @override
  _AlertesState createState() => new _AlertesState();
}

class _AlertesState extends State<Alertes> {
  List alertList = [
    {
      'title': 'WIFI',
      'message': 'Voici le mot de passe du WIFI: 00000000000000000000000',
      'device': 'android',
    },
    {
      'title': 'Test',
      'message': 'Voici un message de test',
      'device': 'ios',
    }
  ];
  bool toggleValue = false;
  bool state = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
            height: 30,
            child: Row(children: [Text('Mes Alertes')]),
          ),
          Column(
            //on utilise pas les crochets pour children car on va generer une liste
            children: alertList.map((alerte) {
              return InkWell(
                  onTap: () => {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AlertScreen(
                                  alerte: new Alert(
                                      title: alerte['title'].toString(),
                                      content: alerte['message'].toString(),
                                      days: [],
                                      cibles: []))),
                        ),
                      },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: d_lightgray,
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    //contenu dans chaque container

                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Text(
                                  alerte['title'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'calibri',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SwitchButton(),
                                      PopupMenuButton<MenuItem>(
                                          onSelected: (item) => {
                                                if (item ==
                                                    MenuItems.itemSettings)
                                                  {
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) => new AlertScreen(
                                                              alerte: new Alert(
                                                                  title: alerte[
                                                                          'title']
                                                                      .toString(),
                                                                  content: alerte[
                                                                          'message']
                                                                      .toString(),
                                                                  days: [],
                                                                  cibles: []))),
                                                    ),
                                                  },
                                                if (item ==
                                                    MenuItems.itemRemove)
                                                  {
                                                    /*
                                                        Remove alert from the list alert['title'],['message']...
                                                  */
                                                  },
                                              },
                                          itemBuilder: (context) => [
                                                ...MenuItems.items
                                                    .map(buildItem)
                                                    .toList(),
                                              ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }).toList(),
          ),
          SizedBox(height: 50),
          Center(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: d_darkgray,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: _onButtonPressed,
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
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FormScreen()),
                ),
                /* 
                        fonction to chose a device
                        */
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.whatsapp,
                ),
                title: Text('WhatsApp'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FormScreen()),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebookMessenger),
                title: Text('Messenger'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FormScreen()),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebook),
                title: Text('Facebook'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FormScreen()),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.instagram),
                title: Text('Instagram'),
                onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FormScreen()),
                ),
              ),
            ],
          );
        });
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );
}

class BottomNavigationBarSection extends StatelessWidget {
  final String value = 'test';

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: d_green,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.access_time,
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
              new MaterialPageRoute(builder: (context) => new FormScreen()),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new HelpScreen(value: value)),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
