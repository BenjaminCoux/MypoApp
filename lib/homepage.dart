import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/alerte.dart';
import 'package:mypo/formulaire_alert.dart';
import 'package:mypo/messagesend.dart';
import 'package:shared_preferences/shared_preferences.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

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
        children: [Logo(), Alertes()],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new MessageScreen()),
        ),
        /*
        
        Test pour envoyer des messages sur le button bleue
        
        */
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

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage('images/logo.png'))),
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
  List _items = [];
  bool toggleValue = false;
  bool state = true;
  String test = "";
  String all = "-1";
  int num=-1;
  List alerts = <dynamic>[];
  //List<bool> _selections = List.generate(2, (_) => false);

  @override
  void initState() {
    initNb();
    readAlert();
    super.initState();
  }

    void initNb() async{
      final prefs = await SharedPreferences.getInstance();
      int tmp = prefs.getInt("nombreAlerte") ?? -1;
      if(tmp == -1){
        prefs.setInt("nombreAlerte", 0);
      }
    }

  void readAlert()async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    Set<String> keys = prefs.getKeys();
    Iterator<String> it = keys.iterator;
    String cc;
    while(it.moveNext()){
      cc=it.current;
      if(cc!="nombreAlerte"){
        alerts.add(json.decode(prefs.getString(cc) ?? "/"));
      }
    }
  }
  Alert fromStrtoJson(String input){
    var res = json.decode(input);
    return res;
  }


  @override
  Widget build(BuildContext context) {
    for(int i=0;i<alerts.length;i++){
      print(alerts[i]);
    }
    /*final tmp = alerts[0];
    final test = tmp;
    final tst = json.decode(test);
    print(tst["title"]);*/
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
            children: alerts.map((alerte) {
              return InkWell(onTap:()=>{
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new AlertScreen(alerte: new Alert(title: alerte["title"], content: alerte["content"], days: jsonDecode(alerte["days"]), cibles:jsonDecode(alerte["cibles"])))),),
              },child:Container(
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
                              alerte["title"],
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
  int nb = 0;
  void getNb() async {
    final pref = await SharedPreferences.getInstance();
    nb = pref.getInt("nombreAlerte")! ;
  }
  @override
  Widget build(BuildContext context) {
    getNb();
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: d_green,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomePage()),
              /*
            () => {
              print('test button accueil'),
            },
            ù*/
            ),
          ),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new FormScreen(nb:nb,)),
              /*
            onPressed: () => {
              print('test button alerte'),
            },
            */
            ),
          ),
          label: 'Alertes',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: () => {
              print('test button aide'),
            },
          ),
          label: 'Aide',
        ),
      ],
    );
  }
}
