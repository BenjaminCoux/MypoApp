import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/formulaire_group_contact_page.dart';
import 'package:mypo/pages/group_contact_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:contacts_service/contacts_service.dart';
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
    return ListTile(
      trailing: IconButton(
          alignment: Alignment.centerRight,
          onPressed: () => {
                setState(() {
                  contactList.remove(number);
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

  void save() {
    widget.grp.name = name.text;
    widget.grp.description = descri.text;
    widget.grp.numbers = contactList;
    widget.grp.save();
  }

/*Future listContact =
        Future.delayed(const Duration(milliseconds: 100), () => getContacts());*/
  buildList(Iterable<Contact> it) {
    Iterator<Contact> c = it.iterator;
    List<Contact> grp = <Contact>[];
    List<String> names = <String>[];
    int i = 0;
    while (c.moveNext()) {
      grp.add(c.current);
    }
    bool set = false;
    for (int i = 0; i < contactList.length; i++) {
      set = false;
      for (int j = 0; j < grp.length; j++) {
        String num = grp[j].phones?.elementAt(0).value! ?? "";
        if (num == contactList[i]) {
          if (grp[j].givenName != null && grp[j].familyName != null) {
            names.add(grp[j].givenName! + " " + grp[j].familyName!);
            set = true;
          } else if (grp[j].givenName != null && grp[j].familyName == null) {
            names.add(grp[j].givenName!);
          } else {
            names.add(grp[j].phones?.elementAt(0).value ?? '');
          }
        }
      }
      if (!set) {
        names.add(contactList[i]);
        set = true;
      }
    }
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
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
        title: "Editer le groupe $title",
        page: () => GroupContactPage(),
      ),
      body: Center(
        child: Column(
          children: [
            buildLabelText('Nom du groupe'),
            buildTextField('Nom', name, 1),
            buildLabelText('Description'),
            buildTextField('Description', descri, 1),
            buildLabelText('Numéro(s) de(s) contact(s)'),
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
                        icon: Icon(Icons.person_add,
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

  Widget buildLabelText(String input) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 3, 5, 0),
      child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Text(
                input,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              )
            ],
          )),
    );
  }
}
