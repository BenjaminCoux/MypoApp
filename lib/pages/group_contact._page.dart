import 'package:flutter/material.dart';
import 'package:mypo/model/group_contact.dart';
import 'package:mypo/pages/formulaire_group_contact_page.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/hamburgermenu_widget.dart';
import 'package:mypo/model/colors.dart';

class GroupContactPage extends StatefulWidget {
  @override
  _GroupContactState createState() => _GroupContactState();
}

class _GroupContactState extends State<GroupContactPage> {
  final groupContact =
      Boxes.getGroupContact().values.toList().cast<GroupContact>();

  buildGroup(BuildContext context, String nom) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: Text(
          nom,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          nom,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          buildButtons(context, nom),
        ],
      ),
    );
  }

  buildButtons(BuildContext context, var alert) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Modifier'),
              icon: Icon(Icons.edit),
              onPressed: () => {
                //Todo page de formulaire
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Supprimer'),
              icon: Icon(Icons.delete),
              onPressed: () => {
                //TODO : suppression
              },
            ),
          )
        ],
      );

  buildListofCOntact(int lenght, dynamic list) {
    return lenght > 0
        ? buildGroup(context, list)
        : Text("Il n'y a pas encore degroupe de contacts enregistrés");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
        title: "Groupes de contact",
        page: () => HomePage(),
      ),
      body: Center(
        child: Column(children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: d_darkgray,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new GroupForm()))
                  },
              child: Text(
                "+ Ajouter un groupe de contact",
                style: TextStyle(
                    backgroundColor: d_darkgray,
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white,
                    fontFamily: 'calibri'),
              )),
          buildListofCOntact(groupContact.length, groupContact),
        ]),
      ),
    );
  }
}
