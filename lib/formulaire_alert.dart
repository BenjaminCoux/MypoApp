import 'package:flutter/material.dart';
import 'package:mypo/main.dart';



class FormScreen extends StatefulWidget{

  @override
  _FormState createState() => _FormState();
}


class _FormState extends State<FormScreen>{
  final alertName = TextEditingController();
  final alertContent = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    print(alertContent.text);
    alertContent.dispose();
    alertName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("alert creation form"),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("add alert Title"),
              TextField(controller: alertName,
              ),
              const Text("add alert content"),
              TextField(controller: alertContent),
              PopupMenuButton(itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(child: Text("choix 1") ),
                const PopupMenuItem(child: Text("Choix 2")),
              ],shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),child: OutlinedButton(onPressed: null,child: const Text("Jours de la semaine"),),),
              PopupMenuButton(itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(child: Text("Lundi") ),
                const PopupMenuItem(child: Text("Mardi")),
              ],shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),child: OutlinedButton(onPressed: null,child: const Text("Cible"),),),
              OutlinedButton(onPressed: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyHomePage(title: "home")),) , child: const Text("Valider")),
            ],
          ),
        ),
      );
    }

}