import 'package:flutter/material.dart';
import 'package:mypo/main.dart';






class FormScreen extends StatefulWidget{

  @override
  _FormState createState() => _FormState();
}





class _FormState extends State<FormScreen>{
  final alertName = TextEditingController();
  final alertContent = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final  week = [false,false,false,false,false,false,false];
  final cibles = [false,false,false];




  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    print(alertContent.text);
    alertContent.dispose();
    alertName.dispose();
    super.dispose();
  }
  void _onFormSaved() {
    final FormState? form = _formKey.currentState;
    form!.save();
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("alert creation form"),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding:EdgeInsets.all(12) ,child: TextField(controller: alertName,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Ajoutez un titre à l'alerte"),
              ),),
              Padding(padding: EdgeInsets.all(12),child: TextField(controller: alertContent,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Contenu du message"),)),
              Padding(padding:EdgeInsets.all(12),child:Row(children:[Text("Jours",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green,))])),
              Padding(padding: EdgeInsets.all(12) ,child:Row(children: [
                Checkbox(value: week[0], onChanged:(bool? value)=>{
                  setState((){
                    week[0]=value!;
                  })
                }),
                Text("lundi"),
                Checkbox(value: week[1], onChanged:(bool? value)=>{
                  setState((){
                    week[1]=value!;
                  })
                }),
                Text("Mardi"),
                Checkbox(value: week[2], onChanged:(bool? value)=>{
                  setState((){
                    week[2]=value!;
                  })
                }),
                Text("Mercredi"),
                Checkbox(value: week[3], onChanged:(bool? value)=>{
                  setState((){
                    week[3]=value!;
                  })
                }),
                Text("Jeudi"),
              ],),),
              Padding(padding: EdgeInsets.all(12),child:Row(
                children: [
                  Checkbox(value: week[4], onChanged:(bool? value)=>{
                    setState((){
                      week[4]=value!;
                    })
                  }),
                  Text("Vendredi"),
                  Checkbox(value: week[5], onChanged:(bool? value)=>{
                    setState((){
                      week[5]=value!;
                    })
                  }),
                  Text("Samedi"),
                  Checkbox(value: week[6], onChanged:(bool? value)=>{
                    setState((){
                      week[6]=value!;
                    })
                  }),
                  Text("Dimanche"),
                ],
              ),),
              Padding(padding: EdgeInsets.all(12),child:Row(children: [Text("Cibles",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green),)],)),
              Padding(padding: EdgeInsets.all(12),
                child: Row(children: [
                  Checkbox(value: cibles[0], onChanged: (bool? value) =>{
                    setState((){
                      cibles[0]=value!;
                    })
                  }),
                  Text("Numéros Enregistrés"),
                  Checkbox(value: cibles[1], onChanged: (bool? value)=>{
                    setState((){
                      cibles[1]=value!;
                    })
                  }),
                  Text("SMS reçu"),
                ],),
              ),
              Padding(padding:EdgeInsets.all(12) ,child: Row(children: [
                Checkbox(value: cibles[2], onChanged: (bool? value)=>{
                  setState((){
                    cibles[2]=value!;
                  })
                }),
                Text("Appels Manqués"),
              ],),),
              OutlinedButton(onPressed: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyHomePage(title: "home")),) , child: const Text("Valider")),
            ],
          ),
        ),
      );
    }

}

class Alert{
  String title;
  String content;
  final days;
  final cibles;

  Alert({required this.title,required this.content,required this.days,required this.cibles});
}


enum Week{Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche}