import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mypo/database/scheduledmsg_database.dart';
import 'package:mypo/model/scheduledmsg.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/boxes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mypo/model/scheduledmsg_hive.dart';

import 'sms_prog_page.dart';

class ProgForm extends StatefulWidget {
  @override
  _ProgState createState() => _ProgState();
}

class _ProgState extends State<ProgForm> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final alertContent = TextEditingController();
  bool rebours = false;
  bool confirm = false;
  bool notif = false;
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false];
  bool SMS = false;
  bool Tel = false;
  bool MMS = false;
  final repeatOptions = [
    'Toutes les heures',
    'Tous les jours',
    'Toutes les semaines',
    'Tous les mois',
    'Tous les ans'
  ];
  int index = 0;
  var repeatinput = 'Tous les ans';
  List<Contact> contacts = [];
  TimeOfDay _time = TimeOfDay.now();
  late TimeOfDay picked;
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  bool fieldsEmpty = true;
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
    nameController.dispose();
    alertContent.dispose();
    contactController.dispose();
    super.dispose();
  }

  Color getColor(bool b) {
    if (b) {
      return d_green;
    }
    return d_darkgray;
  }

  Future<Null> selectTime(BuildContext context) async {
    picked = (await showTimePicker(
          context: context,
          initialTime: _time,
        )) ??
        _time;
    setState(() {
      _time = picked;
      print(_time);
    });
  }

  save() {
    if (contactController.text != '' &&
        alertContent.text != '' &&
        repeatinput != '') {
      Scheduledmsg msg = Scheduledmsg(
        phoneNumber: contactController.text,
        message: alertContent.text,
        date: date,
        repeat: repeatinput,
        countdown: rebours,
        confirm: confirm,
        notification: notif,
      );
      ScheduledMessagesDataBase.instance.create(msg);
    }
  }

  saveToHive() {
    if (contactController.text != '' &&
        alertContent.text != '' &&
        repeatinput != '') {
      final msg = Scheduledmsg_hive()
        ..name = nameController.text
        ..phoneNumber = contactController.text
        ..message = alertContent.text
        ..date = date
        ..repeat = repeatinput
        ..countdown = rebours
        ..confirm = confirm
        ..notification = notif;

      final box = Boxes.getScheduledmsg();
      box.add(msg);
      //box.put('mykey',msg);
    }
  }

  deleteDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'scheduledmsg.db');
    await deleteDatabase(path);
  }

  @override
  Widget build(BuildContext context) {
    // initState();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: 'Ajoutez une alerte'),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Center(
            child: Column(
              children: <Widget>[
                buildTextField("Nom de l'alerte", "Ajoutez un nom à l'alerte",
                    nameController, 1),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.phone,
                      controller: contactController,
                      decoration: InputDecoration(
                        labelText: 'Numero du contact',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.contact_page,
                                size: 35, color: Colors.blue),
                            onPressed: () =>
                                _buildContactSelection(context, contacts)),
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
                buildTextField(
                    'Message', "Contenu du message", alertContent, 3),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: OutlinedButton(
                                  // onPressed: null,
                                  onPressed: () => showSheet(context,
                                      child: buildDatePicker(), onClicked: () {
                                    final value =
                                        DateFormat('dd/MM/yyyy').format(date);
                                    showSnackBar(context, 'date "$value"');
                                    Navigator.pop(context);
                                  }),

                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: d_green, width: 2),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: OutlinedButton(
                                  // onPressed: null,
                                  onPressed: () => showSheet(context,
                                      child: buildTimePicker(), onClicked: () {
                                    final value =
                                        DateFormat('HH:mm').format(time);
                                    showSnackBar(context, 'heure "${value}"');
                                    Navigator.pop(context);
                                  }),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: d_green, width: 2),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Heure",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: OutlinedButton(
                            // onPressed: null,
                            onPressed: () => showSheet(context,
                                child: buildRepeatOptions(), onClicked: () {
                              repeatinput = repeatOptions[index];
                              showSnackBar(context, 'option "${repeatinput}"');
                              Navigator.pop(context);
                            }),

                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: d_green, width: 2),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Récurrence",
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
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
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
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: d_green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async => {
                    if (nameController.text != '' &&
                        contactController.text != '' &&
                        alertContent.text != '')
                      {fieldsEmpty = false},
                    if (!fieldsEmpty)
                      {
                        // save(),

                        // deleteDB(),

                        saveToHive(),
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SmsProg()),
                        )
                      }
                    else
                      {
                        showSnackBar(
                            context, 'Veuillez completer tous les champs')
                      }
                  },
                  child: Text(
                    "Valider",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void test() {
    print('test');
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
          onChanged: (String value) => {
            setState(() {
              // set new state

              // this.contentchanged = true;
              // this.titlechanged = true;
              // this.hasChanged = true;
            })
          },
          minLines: 1,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                              // we set the text of the controller to the number of the contact chosen
                              contactController.text =
                                  contact.phones?.elementAt(0).value! ?? '';
                            },
                          );
                        })
                  ],
                ),
              )));
        });
  }

  Widget buildDatePicker() => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
            minimumYear: DateTime.now().year - 2,
            maximumYear: DateTime.now().year + 3,
            initialDateTime: date,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.date = dateTime)),
      );

  Widget buildTimePicker() => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
            initialDateTime: date,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.time = dateTime)),
      );

  showSheet(BuildContext context,
          {required Widget child, required VoidCallback onClicked}) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  child,
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Valider', style: TextStyle(color: d_green)),
                  onPressed: onClicked,
                ),
              ));

  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s, style: TextStyle(fontSize: 24)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget buildRepeatOptions() => SizedBox(
        height: 200,
        child: CupertinoPicker(
            diameterRatio: 0.8,
            itemExtent: 50,
            looping: true,
            onSelectedItemChanged: (index) =>
                setState(() => this.index = index),
            children: modelBuilder<String>(repeatOptions, (index, option) {
              return Center(child: Text(option));
            })),
      );
  List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
