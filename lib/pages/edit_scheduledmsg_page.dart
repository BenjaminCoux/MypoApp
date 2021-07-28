import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/pages/sms_prog_page.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/database/scheduledmsg_hive.dart';

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

class _ScheduledmsgDetailPageState extends State<ScheduledmsgDetailPage> {
  late final alertName;
  late final alertContact;
  late final alertContent;
  late final alertTime;
  bool countdown = false;
  bool confirm = false;
  bool notification = false;
  bool hasChanged = false;
  String repeat = "";
  late DateTime timeUpdated;

  List<Contact> contacts = [];
  final repeatOptions = [
    'Toutes les heures',
    'Tous les jours',
    'Toutes les semaines',
    'Tous les mois',
    'Tous les ans'
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    alertName = TextEditingController(text: widget.message.name);
    alertContact = TextEditingController(text: widget.message.phoneNumber);
    alertContent = TextEditingController(text: widget.message.message);
    countdown = widget.message.countdown;
    confirm = widget.message.confirm;
    notification = widget.message.notification;

    alertName.addListener(() {
      changed;
    });
    alertContact.addListener(() {
      changed;
    });
    alertContent.addListener(() {
      changed;
    });
    // print(widget.message.repeat);
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
    widget.message.date = timeUpdated;
    widget.message.repeat = repeat;
    widget.message.notification = notification;
    // widget.message.status = MessageStatus.PENDING;
    widget.message.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: TopBarAlerteProg(title: 'Alerte : ${widget.message.name}'),
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
                buildTextField('Nom', '${widget.message.name}', alertName, 1),
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
                      controller: alertContact,
                      decoration: InputDecoration(
                        labelText: 'Numero du contact',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.person_add,
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
                    'Message', '${widget.message.message}', alertContent, 1),
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
                          Text(
                            "Date: ${DateFormat('dd/MM/yyyy').format(widget.message.date)} ",
                            style: TextStyle(fontSize: 16),
                            //textAlign: TextAlign.start,
                          ),
                          Text(
                            "Heure: ${DateFormat('HH:mm').format(widget.message.date)} ",
                            style: TextStyle(fontSize: 16),
                            // textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: OutlinedButton(
                            // onPressed: null,
                            onPressed: () => showSheet(context,
                                child: buildDatePicker(), onClicked: () {
                              // final value =
                              //     DateFormat('dd/MM/yyyy HH:mm').format(alertDate);
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
                        child: Text("Récurrence: ${widget.message.repeat} ",
                            style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: OutlinedButton(
                            // onPressed: null,
                            onPressed: () => showSheet(context,
                                child: buildRepeatOptions(), onClicked: () {
                              Navigator.pop(context);
                              // print(widget.message.date);
                              //print(widget.message.repeat);
                              // print(confirm);
                              // print(notif);
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
                        onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SmsProg()),
                          ),
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
                        onPressed: () {
                          // print('dont forget to save');
                          saveChanges();
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new SmsProg()));
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
              this.hasChanged = true;
            })
          },
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

  Widget buildDatePicker() => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
            minimumYear: widget.message.date.year,
            maximumYear: DateTime.now().year + 3,
            initialDateTime: widget.message.date,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            onDateTimeChanged: (dateTime) =>
                setState(() => timeUpdated = dateTime)),
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
