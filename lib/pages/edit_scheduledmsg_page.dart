import 'package:flutter/material.dart';
import 'package:mypo/model/scheduledmsg_hive.dart';
import 'package:mypo/pages/sms_prog_page.dart';
import 'package:mypo/widget/appbar_widget.dart';

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
  late final alertRepeatOption;
  late final alertDate;
  late final alertTime;
  bool countdown = false;
  bool confirm = false;
  bool notification = false;
  bool hasChanged = false;

  @override
  void initState() {
    super.initState();
    alertName = TextEditingController(text: widget.message.name);
    alertContact = TextEditingController(text: widget.message.phoneNumber);
    alertContent = TextEditingController(text: widget.message.message);
    alertDate = widget.message.date;
    alertRepeatOption = widget.message.repeat;
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
  }

  void changed() {
    this.hasChanged = true;
  }

  void saveChanges() {
    widget.message.name = alertName.text;
    widget.message.phoneNumber = alertContact.text;
    widget.message.message = alertContent.text;
    widget.message.date = alertDate;
    widget.message.repeat = alertRepeatOption;
    widget.message.confirm = confirm;
    widget.message.notification = notification;
    widget.message.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TopBar(title: 'Alerte : ${widget.message.name}'),
      body: Scrollbar(
        thickness: 10,
        interactive: true,
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
                buildTextField(
                    'Message', '${widget.message.message}', alertContent, 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50),
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
                          "CANCEL",
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
                          padding: EdgeInsets.symmetric(horizontal: 50),
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
                          "SAVE",
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
}
