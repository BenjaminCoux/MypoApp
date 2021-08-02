import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/formulaire_group_contact_page.dart';
import 'package:mypo/pages/group_contact_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/model/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class EditGroup extends StatefulWidget {
  GroupContact grp;
  EditGroup({required this.grp});
  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  late TextEditingController name;
  late TextEditingController descri;
  late List<String> contactList;
  final contactController = TextEditingController();
  bool hasChanged = false;

  @override
  void initState() {
    name = TextEditingController(text: widget.grp.name);
    descri = TextEditingController(text: widget.grp.description);
    contactList = widget.grp.numbers;
    name.addListener(() {
      changed;
    });
    descri.addListener(() {
      changed;
    });
    contactController.addListener(() {
      changed;
    });
    super.initState();
  }

  void changed() {
    setState(() {
      hasChanged = true;
    });
  }

  @override
  void dispose() {
    name.dispose();
    descri.dispose();
    contactController.dispose();
    super.dispose();
  }

  buildTile(String number) {
    return Container(
        decoration: BoxDecoration(
          color: d_lightgray,
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [
              Text(number),
              IconButton(
                  onPressed: () => {
                        setState(() {
                          contactList.remove(number);
                        })
                      },
                  icon: Icon(Icons.delete))
            ],
          ),
        ])));
  }

  void save() {
    widget.grp.name = name.text;
    widget.grp.description = descri.text;
    widget.grp.numbers = contactList;
    widget.grp.save();
  }

  buildList() {
    return contactList.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) {
              return buildTile(contactList[index]);
            },
          )
        : Text("Pas encore de contact dans le groupe");
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.grp.name;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
        title: "Editer le groupe $title",
        page: () => GroupContactPage(),
      ),
      body: Center(
        child: Column(
          children: [
            buildTextField(
                'Nom', 'Donner un nom au groupe de contact', name, 1),
            buildTextField('Description', 'Ajouter une description', descri, 1),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextField(
                  minLines: 1,
                  maxLines: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  decoration: InputDecoration(
                    labelText: 'Numero(s) de(s) contact(s)',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.person_add,
                            size: 35, color: Colors.black),
                        onPressed: () async {
                          if (await Permission.contacts.request().isGranted) {
                            try {
                              final contact = await ContactsService
                                  .openDeviceContactPicker();
                              if (contact != null) {
                                if (contactController.text.isEmpty) {
                                  contactController.text =
                                      (contact.phones?.elementAt(0).value! ??
                                          '');
                                } else {
                                  contactController.text += ', ' +
                                      (contact.phones?.elementAt(0).value! ??
                                          '');
                                  contactList.add(
                                      contact.phones?.elementAt(0).value ?? '');
                                }
                                setState(() {
                                  contactList.add(
                                      contact.phones?.elementAt(0).value ?? '');
                                  hasChanged = true;
                                });
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        }),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "Ajoutez un numero de telephone",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            buildList(),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: d_green,
                padding: EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => {
                save(),
                Navigator.pop(
                  context,
                ),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new GroupContactPage())),
              },
              child: Text("Valider"),
            )
          ],
        ),
      ),
    );
  }
}
