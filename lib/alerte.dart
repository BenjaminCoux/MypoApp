import 'package:flutter/material.dart';
import 'package:mypo/homepage.dart';
import 'package:mypo/formulaire_alert.dart';


const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);


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

class AlertScreen extends StatefulWidget {
  Alert alerte;

  AlertScreen({required this.alerte});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Center(child: Column(children: [
        Padding(padding: EdgeInsets.all(10), child: 
          Row(
            children: [Text("Titre de l'alerte")],
          )),
        Padding(padding: EdgeInsets.all(10),
        child: Container(
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
          ),child: Padding(padding: EdgeInsets.all(10),
        child: Text(widget.alerte.title),),
        ),),
        Padding( padding : EdgeInsets.all(10),child:Row(children : [Text("Contenu de l'alerte : ")])),
        Padding(padding: EdgeInsets.all(10),child:Container( decoration: BoxDecoration(
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
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(widget.alerte.content),
          ),
        ),),
        Container(decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),boxShadow: [
          BoxShadow(
            color: d_lightgray,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],),margin: EdgeInsets.fromLTRB(10, 10, 10, 10),child:Column(children: [
          Container(child:Padding(padding:EdgeInsets.all(12),child:Row(children:[Text("Jours",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: d_green,))]))),
          Container(
            child:Padding(padding: EdgeInsets.all(8) ,child:Row(children: [
              Checkbox(activeColor: d_green,value: widget.alerte.days[0], onChanged:(bool? value)=>{
                  setState((){
                    widget.alerte.days[0]=value!;
                  })

              }),
              Text("lundi"),
              Checkbox(activeColor: d_green,value: widget.alerte.days[1], onChanged:(bool? value)=>{

                setState((){
                  widget.alerte.days[1]=value!;
                })

              }),
              Text("Mardi"),
              Checkbox(activeColor: d_green ,value: widget.alerte.days[2], onChanged:(bool? value)=>{

              setState((){
                widget.alerte.days[2]=value!;
              })

              }),
              Text("Mercredi"),
              Checkbox(activeColor: d_green,value: widget.alerte.days[3], onChanged:(bool? value)=>{

              setState((){
                widget.alerte.days[3]=value!;
              })

              }),
              Text("Jeudi"),
            ],),),),
          Container(
            child:Padding(padding: EdgeInsets.all(11),child:Row(
              children: [
                Checkbox(activeColor: d_green,value: widget.alerte.days[4], onChanged:(bool? value)=>{

                setState((){
                  widget.alerte.days[4]=value!;
                })

                }),
                Text("Vendredi"),
                Checkbox(activeColor: d_green,value: widget.alerte.days[5], onChanged:(bool? value)=>{

                  setState((){
                    widget.alerte.days[5]=value!;
                  })

                }),
                Text("Samedi"),
                Checkbox(activeColor: d_green,value: widget.alerte.days[6], onChanged:(bool? value)=>{

                setState((){
                  widget.alerte.days[6]=value!;
                })

                }),
                Text("Dimanche"),
              ],
            ),),),])),
      ],),),

    );
  }
}
