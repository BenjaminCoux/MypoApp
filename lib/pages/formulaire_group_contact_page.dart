import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/group_contact_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/utils/fonctions.dart';
import 'package:mypo/utils/variables.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/couleurs.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:mypo/widget/label_widget.dart';
import 'package:mypo/widget/textfield_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupForm extends StatefulWidget {
  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  TextEditingController name = TextEditingController();
  TextEditingController descri = TextEditingController();
  final contactController = TextEditingController();
  List<String> contactList = <String>[];
  List<String> nameList = <String>[];
  late Iterable<Contact> itc;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    descri.dispose();
    contactController.dispose();
    super.dispose();
  }

  int findNumber(String name) {
    for (int i = 0; i < nameList.length; i++) {
      if (name == nameList[i]) {
        return i;
      }
    }
    return -1;
  }

  void remove(String name) {
    if (nameList.contains(name)) {
      int index = nameList.indexOf(name);
      nameList.remove(name);
      contactList.removeAt(index);
    } else if (contactList.contains(name)) {
      int index = contactList.indexOf(name);
      nameList.removeAt(index);
      contactList.remove(name);
    }
  }

  buildTile(String number) {
    return ListTile(
      trailing: IconButton(
          alignment: Alignment.centerRight,
          onPressed: () => {
                setState(() {
                  remove(number);
                })
              },
          icon: Icon(Icons.delete)),
      title: Text(number),
    );
  }

  void save() {
    if (name.text.length > 0 && contactList.length > 0) {
      final grp = GroupContact()
        ..name = name.text
        ..description = descri.text
        ..numbers = contactList;
      final box = Boxes.getGroupContact();
      box.add(grp);
    }
  }

  buildList() {
    return contactList.length > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: nameList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(child: buildTile(nameList[index]));
            },
          )
        : Text("Pas encore de contact dans le groupe");
  }

  String findName(String val) {
    if (itc != null) {
      Iterator<Contact> it = itc.iterator;
      while (it.moveNext()) {
        if (it.current.phones?.elementAt(0).value == val) {
          if (it.current.givenName != null && it.current.familyName != null) {
            return it.current.givenName! + " " + it.current.familyName!;
          } else {
            return val;
          }
        }
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
        title: "Créer un groupe de contacts",
        page: () => GroupContactPage(),
      ),
      body: Scrollbar(
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: scrollBarThickness,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildLabelText(input: 'Nom'),
                textField('Donner un nom au groupe de contacts', name, 1),
                buildLabelText(input: 'Description'),
                textField('Ajouter une description', descri, 1),
                buildLabelText(input: 'Numéro(s) de contact(s)'),
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
                      onSubmitted: (String? val) async => {
                        itc = await ContactsService.getContacts(),
                        setState(() {
                          contactList.add(val!);
                          nameList.add(findName(val));
                        }),
                        contactController.text = "",
                      },
                      minLines: 1,
                      maxLines: 1,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.phone,
                      controller: contactController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.person_add_outlined,
                                size: 35, color: Colors.black),
                            onPressed: () async {
                              if (await Permission.contacts
                                  .request()
                                  .isGranted) {
                                try {
                                  final contact = await ContactsService
                                      .openDeviceContactPicker();
                                  itc = await ContactsService.getContacts();
                                  if (contact != null) {
                                    setState(() {
                                      contactList.add(
                                          contact.phones?.elementAt(0).value ??
                                              '');
                                      if (contact.givenName == null) {
                                        nameList.add(contact.phones
                                                ?.elementAt(0)
                                                .value ??
                                            '');
                                      } else if (contact.familyName != null) {
                                        nameList.add(contact.givenName! +
                                            " " +
                                            contact.familyName!);
                                      } else {
                                        nameList.add(contact.givenName!);
                                      }
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
                        hintText: "Numéro de téléphone",
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
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: d_green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => {
                    if (name.text == "")
                      {showSnackBar(context, "Veuillez ajouter un nom")}
                    else if (descri.text == "")
                      {
                        showSnackBar(
                            context, "Veuillez ajouter une description")
                      }
                    else if (contactList.length == 0)
                      {showSnackBar(context, "Veuillez ajouter des contacts")}
                    else
                      {
                        save(),
                        Navigator.pop(
                          context,
                        ),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new GroupContactPage())),
                      }
                  },
                  child: Text("Valider"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
