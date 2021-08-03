import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/group_contact_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:contacts_service/contacts_service.dart';
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    descri.dispose();
    contactController.dispose();
    super.dispose();
  }

  buildTile(String number) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
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
          ),
        ])));
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarRedirection(
        title: "Créer un nouveau groupe de contact",
        page: () => GroupContactPage(),
      ),
      body: Scrollbar(
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: 10,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildTextField(
                    'Nom', 'Donner un nom au groupe de contact', name, 1),
                buildTextField(
                    'Description', 'Ajouter une description', descri, 1),
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
                              if (await Permission.contacts
                                  .request()
                                  .isGranted) {
                                try {
                                  final contact = await ContactsService
                                      .openDeviceContactPicker();
                                  if (contact != null) {
                                    if (contactController.text.isEmpty) {
                                      contactController.text = (contact.phones
                                              ?.elementAt(0)
                                              .value! ??
                                          '');
                                    } else {
                                      contactController.text += ', ' +
                                          (contact.phones
                                                  ?.elementAt(0)
                                                  .value! ??
                                              '');
                                      // contactList.add(
                                      //     contact.phones?.elementAt(0).value ?? '');
                                    }
                                    setState(() {
                                      contactList.add(
                                          contact.phones?.elementAt(0).value ??
                                              '');
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
        ),
      ),
    );
  }
}

Container buildTextField(String labelText, String placeholder,
    TextEditingController controller, int nbLines) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(18),
      ),
    ),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: TextField(
        controller: controller,
        onChanged: (String value) => {},
        maxLines: nbLines,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
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
          contentPadding: EdgeInsets.all(8),
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
