import 'package:flutter/material.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:mypo/helppage.dart';
import 'package:mypo/messagesend.dart';
import 'package:mypo/homepage.dart';
import 'package:mypo/alerte.dart';

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
      floatingActionButton: FloatingActionButton(
        /*
        Test pour envoyer des messages sur le button bleue
        */
        onPressed: () => Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new MessageScreen()),
        ),
        tooltip: 'Add',
        child: Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarSection(),
    );
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    },
    {
      'title': 'Test',
      'message': 'Voici un message de test',
    }
  ];
  bool toggleValue = false;
  bool state = true;

  //List<bool> _selections = List.generate(2, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
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
                    height: 100,
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

                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  alerte['title'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'calibri',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                SwitchButton(),
                              ],
                            )),
                        /* Contenu du message d'alerte
                    Text(
                      alerte['message'].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'calibri',
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    */
                      ],
                    ),
                  ));
            }).toList(),
          )
        ],
      ),
    );
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
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
            onPressed: null,
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
              /*
            onPressed: () => {
              print('test button alerte'),
            },
            */
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
              /*
            onPressed: () => {
              print('test button aide'),
            },
          ),
          */
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
