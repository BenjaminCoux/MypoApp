import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/edit_groupcontact_page.dart';
import 'package:mypo/pages/formulaire_group_contact_page.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/couleurs.dart';

class GroupContactPage extends StatefulWidget {
  @override
  _GroupContactState createState() => _GroupContactState();
}

class _GroupContactState extends State<GroupContactPage> {
  late List<GroupContact> groupContact;
  late Iterable<Contact> list;

  @override
  void initState() {
    super.initState();
    //to fix
    list = new Iterable.empty();
    groupContact = Boxes.getGroupContact().values.toList().cast<GroupContact>();
  }

  buildGroup(BuildContext context, GroupContact contact) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 20, 5),
      color: Colors.white,
      child: ExpansionTile(
        iconColor: d_green,
        textColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: Text(
          contact.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          contact.description,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          buildButtons(context, contact),
        ],
      ),
    );
  }

  String getNbAlerte(String title) {
    int highest = 0;
    for (int i = 0; i < groupContact.length; i++) {
      String tt =
          title.contains('-') ? title.substring(0, title.indexOf('-')) : title;
      if (groupContact[i].name.contains(tt)) {
        int j = 0;
        String tmp = groupContact[i].name;
        String nb = "";
        bool after = false;
        while (j < tmp.length) {
          if (after) {
            nb += tmp[j];
          }
          if (tmp[j] == "-") {
            after = true;
          }
          j++;
        }
        if (nb == "") {
          nb = "0";
        }
        if (int.parse(nb) > highest) {
          highest = int.parse(nb);
        }
        nb = "";
      }
    }
    int tiret = title.indexOf('-');
    if (title.contains('-')) {
      return title.substring(0, tiret) + "-" + (highest + 1).toString();
    } else {
      return title + "-" + (highest + 1).toString();
    }
  }

  void addToDB(GroupContact g) async {
    GroupContact a = GroupContact()
      ..name = g.name
      ..description = g.description
      ..numbers = g.numbers;
    final box = Boxes.getGroupContact();
    box.add(a);
  }

  buildButtons(BuildContext context, GroupContact contact) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Modifier'),
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new EditGroup(
                              grp: contact,
                              contacts: list,
                            )));
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Dupliquer'),
              icon: Icon(Icons.copy),
              onPressed: () => {
                setState(() {
                  String title = getNbAlerte(contact.name);
                  GroupContact g = GroupContact()
                    ..name = title
                    ..description = contact.description
                    ..numbers = contact.numbers;
                  addToDB(g);
                  groupContact = Boxes.getGroupContact()
                      .values
                      .toList()
                      .cast<GroupContact>();
                }),
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(primary: d_darkgray),
              label: Text('Supprimer'),
              icon: Icon(Icons.delete),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        buildPopupDialog(contact)),
              },
            ),
          )
        ],
      );

  buildListofCOntact(int lenght, List<GroupContact> list) {
    return lenght > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final groupe = list[index];
              return buildGroup(context, groupe);
            })
        : Column(
            children: [Text("Aucun groupe de contacts enregistré")],
          );
  }

  buildPopupDialog(GroupContact contact) {
    String title = "";
    title = contact.name;
    return new AlertDialog(
      title: Text("Voulez vous supprimer $title ?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            setState(() {
              contact.delete();
              groupContact.remove(contact);
            });
            Navigator.of(context).pop();
          },
          child: const Text('Oui', style: TextStyle(color: Colors.black)),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Non', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
        title: "Groupes de contacts",
        page: () => HomePage(),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 10),
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
                "+ Ajouter un groupe de contacts",
                style: TextStyle(
                    backgroundColor: d_darkgray,
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white,
                    fontFamily: 'calibri'),
              )),
          SizedBox(height: 10),
          buildListofCOntact(groupContact.length, groupContact),
        ]),
      ),
    );
  }
}
