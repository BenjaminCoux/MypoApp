import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/formulaire_group_contact_page.dart';
import 'package:mypo/pages/group_contact_page.dart';
import 'package:mypo/utils/fonctions.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/couleurs.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:mypo/widget/label_widget.dart';
import 'package:mypo/widget/textfield_widget.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class EditGroup extends StatefulWidget {
  GroupContact grp;
  Iterable<Contact> contacts;
  EditGroup({required this.grp, required this.contacts});
  @override
  _EditGroupState createState() => _EditGroupState();
}

String findName(String me, Iterable<Contact> contact) {
  Iterator<Contact> it = contact.iterator;
  while (it.moveNext()) {
    if (it.current.phones?.first.value == me) {
      if (it.current.givenName != null) {
        return it.current.givenName!;
      } else {
        String res = it.current.phones?.elementAt(0).value! ?? "";
        return res;
      }
    }
  }
  return me;
}

class _EditGroupState extends State<EditGroup> {
  late TextEditingController name;
  late TextEditingController descri;
  late List<String> contactList;
  late List<String> nameList;
  List<String> names = <String>[];
  Iterable<Contact> contacts = Iterable.empty();
  final contactController = TextEditingController();
  bool hasChanged = false;
  void getContacts() async {
    this.contacts = await ContactsService.getContacts();
  }

  @override
  void initState() {
    name = TextEditingController(text: widget.grp.name);
    descri = TextEditingController(text: widget.grp.description);
    contactList = widget.grp.numbers;
    getC();
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

  @override
  void dispose() {
    name.dispose();
    descri.dispose();
    contactController.dispose();
    super.dispose();
  }

  void changed() {
    setState(() {
      hasChanged = true;
    });
  }

  void removefromName(String name) {
    for (int i = 0; i < names.length; i++) {
      if (names[i] == name) {
        contactList.removeAt(i);
      }
    }
  }

  buildTile(String number) {
    return ListTile(
      trailing: IconButton(
          alignment: Alignment.centerRight,
          onPressed: () => {
                setState(() {
                  removefromName(number);
                  names.remove(number);
                })
              },
          icon: Icon(Icons.delete)),
      title: Text(number),
    );
  }

  Future<Iterable> getC() async {
    Iterable<Contact> i = await ContactsService.getContacts();
    contacts = i;
    return i;
  }

  String findName(String val, Iterator<Contact> it) {
    while (it.moveNext()) {
      if (it.current.phones?.elementAt(0).value == val) {
        if (it.current.givenName != null && it.current.familyName != null) {
          return it.current.givenName! + " " + it.current.familyName!;
        } else if (it.current.givenName != null &&
            it.current.familyName == null) {
          return it.current.givenName!;
        } else {
          return val;
        }
      }
    }
    return val;
  }

  void buildNames() {
    names = <String>[];
    for (int i = 0; i < contactList.length; i++) {
      Iterator<Contact> tmp = contacts.iterator;
      names.add(findName(contactList[i], tmp));
    }
  }

  void save() {
    widget.grp.name = name.text;
    widget.grp.description = descri.text;
    widget.grp.numbers = contactList;
    widget.grp.save();
  }

  buildList(Iterable<Contact> it) {
    buildNames();
    return contactList.length > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(child: buildTile(names[index]));
            },
          )
        : Text("Pas encore de contact dans le groupe");
  }

  final Future<Iterable<Contact>> list = Future<Iterable<Contact>>.delayed(
    const Duration(microseconds: 2),
    () => ContactsService.getContacts(),
  );
  @override
  Widget build(BuildContext context) {
    String title = widget.grp.name;
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
        title: "Editer le groupe $title",
        page: () => GroupContactPage(),
      ),
      body: Center(
        child: Column(
          children: [
            buildLabelText(input: 'Nom du groupe'),
            textField('Nom', name, 1),
            buildLabelText(input: 'Description'),
            textField('Description', descri, 1),
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
                  onSubmitted: (String? v) => {
                    setState(() {
                      contactList.add(v!);
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
                          if (await Permission.contacts.request().isGranted) {
                            try {
                              final contact = await ContactsService
                                  .openDeviceContactPicker();
                              if (contact != null) {
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
            FutureBuilder(
                future: list,
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<Contact>> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    children = <Widget>[buildList(contacts)];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 60),
                    ];
                  } else {
                    children = <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(
                          color: d_green,
                        ),
                        width: 60,
                        height: 60,
                      ),
                    ];
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                }),
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
                  {showSnackBar(context, "Veuillez ajouter une description")}
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
    );
  }
}
