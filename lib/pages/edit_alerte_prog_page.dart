import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/model/expressions.dart';
import 'package:mypo/pages/edit_alerte_auto_page.dart';
import 'package:mypo/pages/formulaire_alerte_auto_page.dart';
import 'package:mypo/pages/sms_prog_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/utils/fonctions.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ScheduledmsgDetailPage extends StatefulWidget {
  late Scheduledmsg_hive message;
  ScheduledmsgDetailPage({
    Key? key,
    required this.message,
  }) : super(key: key);
  @override
  _ScheduledmsgDetailPageState createState() => _ScheduledmsgDetailPageState();
}

String getHintgrpCo(List<GroupContact> l) {
  String res = "";
  for (int i = 0; i < l.length; i++) {
    if (i != l.length - 1) {
      res += l[i].name + ', ';
    } else {
      res += l[i].name;
    }
  }
  return res;
}

class _ScheduledmsgDetailPageState extends State<ScheduledmsgDetailPage> {
  late final alertName;
  final contactgroup =
      Boxes.getGroupContact().values.toList().cast<GroupContact>();
  late final alertContact;
  late final alertContent;
  late final alertTime;
  bool countdown = false;
  bool confirm = false;
  bool notification = false;
  bool hasChanged = false;
  bool wordsLimit = true;
  late List<GroupContact> alertgrp;
  String repeat = "";
  late DateTime timeUpdated;
  late DateTime timeAux;
  int nbMaxWords = 450;
  int nbWords = 0;
  late final groupcontactcontroller;
  late List<bool> boolCheckedGrp;
  List<Contact> contacts = [];
  final repeatOptions = [
    'Toutes les heures',
    'Tous les jours',
    'Toutes les semaines',
    'Tous les mois',
    'Tous les ans',
    'Aucune récurrence'
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    alertName = TextEditingController(text: widget.message.name);
    alertContact = TextEditingController(text: widget.message.phoneNumber);
    alertContent = TextEditingController(text: widget.message.message);
    alertgrp = widget.message.groupContact;
    groupcontactcontroller =
        TextEditingController(text: getHintgrpCo(widget.message.groupContact));
    countdown = widget.message.countdown;
    confirm = widget.message.confirm;
    notification = widget.message.notification;
    timeUpdated = widget.message.date;
    timeAux = widget.message.date;
    repeat = widget.message.repeat;
    boolCheckedGrp =
        buildboolListEdit(contactgroup, widget.message.groupContact);
    alertName.addListener(() {
      changed;
    });
    alertContact.addListener(() {
      changed;
    });
    alertContent.addListener(() {
      changed;
    });
    // debugPrint(widget.message.status.toString());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alertName.dispose();
    alertContent.dispose();
    alertContact.dispose();
    super.dispose();
  }

  void changed() {
    this.hasChanged = true;
  }

  void saveChanges() {
    widget.message.name = alertName.text;
    widget.message.phoneNumber = alertContact.text;
    widget.message.message = alertContent.text;
    widget.message.countdown = countdown;
    widget.message.confirm = confirm;
    widget.message.groupContact = alertgrp;
    widget.message.date = new DateTime(timeUpdated.year, timeUpdated.month,
        timeUpdated.day, timeAux.hour, timeAux.minute, timeAux.second);
    widget.message.dateOfCreation = new DateTime(
        timeUpdated.year,
        timeUpdated.month,
        timeUpdated.day,
        timeAux.hour,
        timeAux.minute,
        timeAux.second);
    widget.message.repeat = repeat;

    widget.message.notification = notification;
    widget.message.status = true;
    widget.message.save();
  }

  bool sameName(String n) {
    List<Scheduledmsg_hive> alerts =
        Boxes.getScheduledmsg().values.toList().cast<Scheduledmsg_hive>();
    for (int i = 0; i < alerts.length; i++) {
      if (alerts[i].name == n && widget.message.name != n) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_grey,
      appBar: TopBarRedirection(
          title: 'Alerte : ${widget.message.name}', page: () => SmsProg()),
      body: Scrollbar(
        thickness: 10,
        interactive: true,
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: Container(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              children: <Widget>[
                buildLabelText("Nom"),
                buildTextFieldMessage('${widget.message.name}', alertName, 1),
                buildLabelText('Numéro(s) de contact(s)'),
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
                      onChanged: (text) {},
                      minLines: 1,
                      maxLines: 1,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.phone,
                      controller: alertContact,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.person_add_outlined,
                                size: 35, color: Colors.black),
                            onPressed: () async {
                              try {
                                final contact = await ContactsService
                                    .openDeviceContactPicker();
                                if (contact != null) {
                                  if (alertContact.text.isEmpty) {
                                    alertContact.text =
                                        (contact.phones?.elementAt(0).value! ??
                                            '');
                                  } else {
                                    alertContact.text += ', ' +
                                        (contact.phones?.elementAt(0).value! ??
                                            '');
                                  }
                                }
                              } catch (e) {
                                debugPrint(e.toString());
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
                Text(
                  "ou",
                  textAlign: TextAlign.center,
                ),
                buildLabelText("Groupe(s) de contacts"),
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
                                            alertGroup: alertgrp,
                                            boolCheckedGrp: boolCheckedGrp,
                                            controller: groupcontactcontroller,
                                          );
                                        }),
                                    setState(() {
                                      String tmp = "";
                                      for (int i = 0;
                                          i <
                                              widget
                                                  .message.groupContact.length;
                                          i++) {
                                        tmp +=
                                            widget.message.groupContact[i].name;
                                      }
                                      groupcontactcontroller.text = tmp;
                                    })
                                  },
                              icon: Icon(
                                Icons.group_add_outlined,
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
                buildTextFieldMessage(
                    '${widget.message.message}', alertContent, 4),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Date de création ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  "${DateFormat('dd/MM/yyyy').format(timeUpdated)} ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Heure: ${DateFormat('HH:mm').format(timeAux)} ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Date du prochain envoi ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  "${DateFormat('dd/MM/yyyy').format(timeUpdated)} ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Heure: ${DateFormat('HH:mm').format(timeAux)} ",
                                  style: TextStyle(fontSize: 16),
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
                              Navigator.pop(context);
                              showSnackBar(context,
                                  'Date: ${DateFormat('dd/MM/yyyy').format(timeUpdated)} Heure: ${DateFormat('HH:mm').format(timeAux)}');
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
                              "Changer la date ",
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
                              repeat != ''
                                  ? "${repeat} "
                                  : "${widget.message.repeat}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
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
                              "Changer la récurrence",
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
                                  child: Text(
                                    "Compte à rebours",
                                  ),
                                  margin: EdgeInsets.all(5)),
                            ],
                          )),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Switch(
                                activeColor: d_green,
                                value: countdown,
                                onChanged: (bool val) => {
                                      setState(() {
                                        countdown = val;
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
                              Icon(Icons.check_circle_outlined),
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
                              Icon(Icons.notifications_outlined),
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
                                value: notification,
                                onChanged: (bool val) => {
                                      setState(() {
                                        notification = val;
                                      })
                                    }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  buildPopupDialogCancel());
                        },
                        child: Text(
                          "Annuler",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: d_green,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async => {
                          if (alertName.text == '')
                            {
                              {
                                showSnackBar(context,
                                    "Veuillez rentrer un nom à l'alerte.")
                              }
                            }
                          else if (alertContact.text == '' &&
                              widget.message.groupContact.length == 0)
                            {
                              showSnackBar(
                                  context, "Veuillez rentrer un numéro.")
                            }
                          else if (!phoneExpression
                                  .hasMatch(alertContact.text) &&
                              widget.message.groupContact.length == 0)
                            {
                              showSnackBar(context,
                                  "Veuillez rentrer de(s) numéro(s) valide")
                            }
                          else if (sameName(alertName.text))
                            {
                              showSnackBar(
                                  context, "Le nom de l'alerte existe déjà")
                            }
                          else if (alertContent.text == '')
                            {
                              showSnackBar(
                                  context, "Veuillez écrire un message")
                            }
                          else if (wordsLimit == false)
                            {
                              {
                                showSnackBar(context,
                                    "Nombre de caractère maximal dépassé")
                              }
                            }
                          else if (!regularExpression.hasMatch(alertName.text))
                            {
                              showSnackBar(context,
                                  "Caractères invalides pour le nom de l'alerte")
                            }
                          else if (!hasChanged)
                            {showSnackBar(context, "Aucune modification")}
                          else if (alertName.text != '' &&
                              (alertContact.text != '' ||
                                  widget.message.groupContact.length > 0) &&
                              alertContent.text != '' &&
                              wordsLimit &&
                              hasChanged &&
                              await Permission.contacts.request().isGranted &&
                              await Permission.sms.request().isGranted)
                            {
                              saveChanges(),
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
                                        'Veuillez activer les permissions (sms et contacts)')
                                  }
                                }
                              else
                                {
                                  showSnackBar(context,
                                      'Veuillez compléter tous les champs')
                                }
                            }
                        },
                        child: Text(
                          "Sauvegarder",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
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

  buildPopupDialogCancel() {
    return new AlertDialog(
      title: Text("Voulez vous annuler ?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SmsProg()),
            );
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
              this.hasChanged = true;
            })
          },
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
              this.hasChanged = true;
              this.nbWords = value.length;
              this.hasChanged = true;
              this.nbMaxWords = 450 - value.length;
              if (this.nbMaxWords < 0) {
                this.wordsLimit = false;
              } else {
                this.wordsLimit = true;
              }
            })
          },
          maxLines: nbLines,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
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
        child: Flex(direction: Axis.horizontal, children: [
          Flexible(
            flex: 7,
            child: CupertinoDatePicker(
              minimumYear: DateTime.now().year,
              maximumYear: DateTime.now().year + 3,
              initialDateTime: widget.message.date,
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  timeUpdated = dateTime;
                  hasChanged = true;
                });
              },
            ),
          ),
          Flexible(
              flex: 3,
              child: CupertinoDatePicker(
                  minimumYear: widget.message.date.year - 3,
                  maximumYear: DateTime.now().year + 3,
                  initialDateTime: widget.message.date,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (dateTime) {
                    setState(() {
                      timeAux = dateTime;
                      hasChanged = true;
                    });
                  })),
        ]),
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

  Widget buildRepeatOptions() => SizedBox(
        height: 200,
        child: CupertinoPicker(
            diameterRatio: 0.8,
            itemExtent: 50,
            looping: true,
            onSelectedItemChanged: (index) => setState(() {
                  repeat = repeatOptions[index];
                  hasChanged = true;
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
