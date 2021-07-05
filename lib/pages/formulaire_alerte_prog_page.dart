import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:quiver/core.dart';

import 'sms_prog_page.dart';

class ProgForm extends StatefulWidget {
  @override
  _ProgState createState() => _ProgState();
}

class _ProgState extends State<ProgForm> {
  final number = TextEditingController();
  final alertContent = TextEditingController();
  bool repeat = false;
  bool rebours = false;
  bool confirm = false;
  bool notif = false;
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false];
  bool SMS = false;
  bool Tel = false;
  bool MMS = false;
  final repeatOptions = [
    'Evenement ponctuel',
    'Toutes les heures',
    'Tous les jours',
    'Toutes les semaines',
    'Tous les mois',
    'Tous les ans'
  ];
  final _isRepeatOptionActive = [false, false, false, false, false, false];
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
    if (await Permission.contacts.request().isGranted) {
      // Get all contacts without thumbnail (faster)
      List<Contact> _contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
      setState(() {
        contacts = _contacts;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alertContent.dispose();
    number.dispose();
    super.dispose();
  }

  Color getColor(bool b) {
    if (b) {
      return d_green;
    }
    return d_darkgray;
  }

  @override
  Widget build(BuildContext context) {
    // initState();
    return Scaffold(
      appBar: TopBar(title: 'Ajoutez une alertee'),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
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
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: number,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.contact_page,
                              size: 35,
                            ),
                            onPressed: () =>
                                _buildContactSelection(context, contacts)),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: d_green)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black)),
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
                Container(
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
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: TextField(
                        controller: alertContent,
                        decoration: InputDecoration(
                          labelText: 'Contenu',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: d_green)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Contenu du message",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      )),
                ),
                Container(
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
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
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
                              child: InkWell(
                                onTap: () => {
                                  setState(() {
                                    if (!SMS) {
                                      this.SMS = true;
                                    } else {
                                      this.SMS = false;
                                    }
                                  })
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: SMS ? d_green : d_darkgray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "15 minutes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
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
                              ),
                              child: InkWell(
                                onTap: () => {
                                  setState(() {
                                    if (!Tel) {
                                      this.Tel = true;
                                    } else {
                                      this.Tel = false;
                                    }
                                  })
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Tel ? d_green : d_darkgray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "30 minutes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
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
                              ),
                              child: InkWell(
                                onTap: () => {
                                  setState(() {
                                    if (!MMS) {
                                      this.MMS = true;
                                    } else {
                                      this.MMS = false;
                                    }
                                  })
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: MMS ? d_green : d_darkgray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "1 heure",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
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
                          child: OutlinedButton(
                            onPressed: () {},
                            // => Navigator.push(
                            //   context,
                            //   new MaterialPageRoute(
                            //       builder: (context) => new Teest()),
                            // ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Personaliser",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                letterSpacing: 2.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*
                    pop up menu with options
                    */
                    _showSingleChoiceDialog(context, _isRepeatOptionActive);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text("Repeter"),
                          margin: EdgeInsets.fromLTRB(5, 0, 280 - 1.6, 0),
                        ),
                        Switch(
                            activeColor: d_green,
                            value: repeat,
                            onChanged: (bool val) => {
                                  setState(() {
                                    repeat = val;
                                  })
                                }),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text("Compte à rebours"),
                        margin: EdgeInsets.fromLTRB(5, 0, 220 - 4.6, 0),
                      ),
                      Switch(
                          activeColor: d_green,
                          value: rebours,
                          onChanged: (bool val) => {
                                setState(() {
                                  rebours = val;
                                })
                              }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text("Confirmer avant envoi"),
                        margin: EdgeInsets.fromLTRB(5, 0, 220 - 29.6, 0),
                      ),
                      Switch(
                          activeColor: d_green,
                          value: confirm,
                          onChanged: (bool val) => {
                                setState(() {
                                  confirm = val;
                                })
                              }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text("Notification"),
                        margin: EdgeInsets.fromLTRB(5, 0, 254, 0),
                      ),
                      Switch(
                          activeColor: d_green,
                          value: notif,
                          onChanged: (bool val) => {
                                setState(() {
                                  notif = val;
                                })
                              }),
                    ],
                  ),
                ),
                OutlinedButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SmsProg()),
                          )
                        },
                    child:
                        const Text("Valider", style: TextStyle(color: d_green)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSingleChoiceDialog(BuildContext context, var _isRepeatOptionActive) =>
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Repeter'),
                content: SingleChildScrollView(
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: repeatOptions
                              .map((option) => CheckboxListTile(
                                    title: Text(option),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: d_green,
                                    value: _isRepeatOptionActive[
                                        repeatOptions.indexOf(option)],
                                    onChanged: (bool? value) => {
                                      setState(() {
                                        _isRepeatOptionActive[repeatOptions
                                            .indexOf(option)] = value!;
                                      }),
                                      Navigator.of(context).pop(),
                                    },
                                  ))
                              .toList(),
                        ))));
          });

  _buildContactSelection(BuildContext context, var contacts) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Contacts'),
              content: SingleChildScrollView(
                  child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = contacts[index];
                          return ListTile(
                            title: Text(contact.displayName ?? ' '),
                            subtitle:
                                Text(contact.phones?.elementAt(0).value! ?? ''),
                            leading: (contact.avatar != null &&
                                    contact.avatar!.length > 0)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!))
                                : CircleAvatar(
                                    foregroundColor: Colors.white,
                                    backgroundColor: d_green,
                                    child: Text(contact.initials())),
                            onTap: () {
                              // selected contact
                              // print('contact ' + index.toString());
                              Navigator.of(context).pop();
                              number.text =
                                  contact.phones?.elementAt(0).value! ?? '';
                            },
                          );
                        })
                  ],
                ),
              )));
        });
  }
}
