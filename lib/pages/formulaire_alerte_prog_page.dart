import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/formulaire_alerte_auto_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:permission_handler/permission_handler.dart';

import 'sms_prog_page.dart';

class ProgForm extends StatefulWidget {
  @override
  _ProgState createState() => _ProgState();
}

class _ProgState extends State<ProgForm> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final alertContent = TextEditingController();
  final contactgroup =
      Boxes.getGroupContact().values.toList().cast<GroupContact>();
  List<GroupContact> alertGroup = <GroupContact>[];
  late List<bool> boolCheckedGrp;
  bool rebours = false;
  bool confirm = false;
  bool notif = false;
  final week = [false, false, false, false, false, false, false];
  final cibles = [false, false, false, false, false, false];
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
  late TimeOfDay picked;
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  bool fieldsEmpty = true;
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  final regularExpression =
      RegExp(r'^[a-zA-Z0-9_\-@,.ãàÀéÉèÈíÍôóÓúüÚçÇñÑ@ \.;]+$');
  final numeroExpression =
      RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  final phoneExpression = RegExp(r'^[0-9_\-+() \.,;]+$');
  int nbMaxWords = 450;
  bool wordsLimit = true;
  int nbWords = 0;
  final groupcontactcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    boolCheckedGrp = buildboolList(contactgroup);
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

  saveToHive() {
    if ((contactController.text != '' || alertGroup.length > 0) &&
        alertContent.text != '' &&
        repeatinput != '') {
      List<GroupContact> grp = <GroupContact>[];
      for (int i = 0; i < alertGroup.length; i++) {
        final tmp = GroupContact()
          ..name = alertGroup[i].name
          ..description = alertGroup[i].description
          ..numbers = alertGroup[i].numbers;
        grp.add(tmp);
      }
      final msg = Scheduledmsg_hive()
        ..name = nameController.text
        ..phoneNumber = contactController.text
        ..message = alertContent.text
        ..date = date
        ..dateOfCreation = date
        ..repeat = repeatinput
        ..countdown = rebours
        ..confirm = confirm
        ..notification = notif
        ..groupContact = grp;

      final box = Boxes.getScheduledmsg();
      box.add(msg); // automatically generates a autoincrement key
      //box.put('mykey',msg); // if we want to put a particular key
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar:
          TopBarRedirection(title: 'Ajouter une alerte', page: () => SmsProg()),
      body: Scrollbar(
        thickness: 5,
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: SingleChildScrollView(
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
                  buildLabelText("Nom de l'alerte"),
                  buildTextField("Nom", nameController, 1),
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
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                } else {
                                  showSnackBar(context,
                                      "Veuillez activer les permissions d'accès aux contacts");
                                }
                              }),
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
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
                  Text("ou"),
                  buildLabelText("Groupes de contacts"),
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
                        keyboardType: TextInputType.text,
                        controller: groupcontactcontroller,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MyDialog(
                                                contactgroup: contactgroup,
                                                alertGroup: alertGroup,
                                                boolCheckedGrp: boolCheckedGrp);
                                          }),
                                      setState(() {
                                        String tmp = "";
                                        for (int i = 0;
                                            i < alertGroup.length;
                                            i++) {
                                          tmp += alertGroup[i].name;
                                        }
                                        groupcontactcontroller.text = tmp;
                                      })
                                    },
                                icon: Icon(
                                  Icons.group_add_rounded,
                                  color: Colors.black,
                                  size: 35,
                                )),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Groupe de contact",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                  buildLabelText('Message'),
                  buildTextFieldMessage("Contenu du message", alertContent, 4),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Date:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "${DateFormat('dd/MM/yyyy').format(date)} ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Heure:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "${DateFormat('HH:mm').format(date)}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: OutlinedButton(
                              onPressed: () => showSheet(context,
                                  child: buildDatePicker(), onClicked: () {
                                final value =
                                    DateFormat('dd/MM/yyyy HH:mm').format(date);
                                showSnackBar(context, 'Date "$value"');
                                Navigator.pop(context);
                              }),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: d_green,
                                side: BorderSide(color: d_green, width: 2),
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Date ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Récurrence:  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              Text(
                                "${repeatinput} ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: OutlinedButton(
                              onPressed: () => showSheet(context,
                                  child: buildRepeatOptions(), onClicked: () {
                                repeatinput = repeatOptions[index];
                                showSnackBar(
                                    context, 'Option "${repeatinput}"');
                                Navigator.pop(context);
                              }),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: d_green,
                                side: BorderSide(color: d_green, width: 2),
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Récurrence",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.79,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.timer_rounded),
                                Container(
                                    child: Text("Compte à rebours",
                                        style: TextStyle(color: Colors.red)),
                                    margin: EdgeInsets.all(5)),
                              ],
                            )),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.79,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_rounded),
                                Container(
                                    child: Text("Confirmer avant envoi"),
                                    margin: EdgeInsets.all(5)),
                              ],
                            )),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.79,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.notifications),
                                Container(
                                    child: Text("Notification"),
                                    margin: EdgeInsets.all(5)),
                              ],
                            )),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: OutlinedButton(
                        onPressed: () async => {
                          if (nameController.text == '')
                            {
                              {
                                showSnackBar(context,
                                    "Veuillez rentrer un nom à l'alerte.")
                              }
                            }
                          else if (contactController.text == '' &&
                              alertGroup.length == 0)
                            {
                              showSnackBar(
                                  context, "Veuillez rentrer un numéro.")
                            }
                          else if (!phoneExpression
                              .hasMatch(contactController.text))
                            {
                              showSnackBar(context,
                                  "Veuillez rentrer de(s) numéro(s) valide.")
                            }
                          else if (alertContent.text == '')
                            {
                              showSnackBar(
                                  context, "Veuillez écrire un message.")
                            }
                          else if (wordsLimit == false)
                            {
                              showSnackBar(context,
                                  "Nombre de character maximal dépassé.")
                            }
                          else if (!regularExpression
                              .hasMatch(nameController.text))
                            {
                              showSnackBar(context,
                                  "Characters invalides pour le nom de l'alerte.")
                            }
                          else if (nameController.text != '' &&
                              (contactController.text != '' ||
                                  alertGroup.length > 0) &&
                              alertContent.text != '' &&
                              wordsLimit &&
                              await Permission.contacts.request().isGranted &&
                              await Permission.sms.request().isGranted)
                            {
                              fieldsEmpty = false,
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
                              if (!(await Permission.sms.isGranted) &&
                                  !(await Permission.contacts.isGranted))
                                {
                                  {
                                    showSnackBar(context,
                                        'Veuillez activer les permissions (sms et contacts).')
                                  }
                                }
                              else
                                {
                                  showSnackBar(context,
                                      'Veuillez completer tous les champs')
                                }
                            }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: d_green,
                          side: BorderSide(color: d_green, width: 2),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Valider",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Container buildTextField(
      String placeholder, TextEditingController controller, int nbLines) {
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
            })
          },
          minLines: 1,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLines: nbLines,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
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

  Container buildTextFieldMessage(
      String placeholder, TextEditingController controller, int nbLines) {
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
              this.nbWords = value.length;
              this.nbMaxWords = 450 - value.length;
              if (this.nbMaxWords < 0) {
                this.wordsLimit = false;
              } else {
                this.wordsLimit = true;
              }
            })
          },
          maxLines: nbLines,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorText: wordsLimit ? null : '${this.nbWords}/450',
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

  Widget buildDatePicker() => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
            minimumYear: DateTime.now().year - 2,
            maximumYear: DateTime.now().year + 3,
            initialDateTime: date,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.date = dateTime)),
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
      content: Text(s, style: TextStyle(fontSize: 20)),
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
            onSelectedItemChanged: (index) => setState(() {
                  this.index = index;
                  repeatinput = repeatOptions[index];
                }),
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
