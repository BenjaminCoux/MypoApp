import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  final String value;
  HelpScreen({required this.value});
  @override
  _HelpScreenState createState() => new _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  static final List<String> items = <String>[
    'Remarques/Suggestions',
    'Questions'
  ];
  String value = items.first;
  late final email;
  List<String> attachments = [];
  bool isHTML = false;
  int nbMaxWords = 450;
  bool wordsLimit = true;
  int nbWords = 0;

  @override
  Widget build(BuildContext context) {
    User_hive? user;
    List users = Boxes.getUser().values.toList().cast<User_hive>();
    if (!users.isEmpty) {
      user = users[0];
      nomController.text = user!.firstname + ' ' + user.name;
      emailController.text = user.email;
    }
    return Scaffold(
        backgroundColor: d_grey,
        appBar: TopBarRedirection(title: "Aide", page: () => HomePage()),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                textColor: d_green,
                                childrenPadding: EdgeInsets.all(16),
                                title: Text(
                                    "Question 1 : Ceci est une questions qui peut être modifier par la suite"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                children: [
                                  Text(
                                      "Voici la reponse a la question 1 qui peut être modifier par la suite")
                                ],
                              ),
                            ),
                            _buildDivider(),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                textColor: d_green,
                                childrenPadding: EdgeInsets.all(16),
                                title: Text(
                                    "Question 2 : Ceci est une questions qui peut être modifier par la suite"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                children: [
                                  Text(
                                      "Voici la reponse a la question 2 qui peut être modifier par la suite")
                                ],
                              ),
                            ),
                            _buildDivider(),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                textColor: d_green,
                                childrenPadding: EdgeInsets.all(16),
                                title: Text(
                                    "Question 3 : Ceci est une questions qui peut être modifier par la suite"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                children: [
                                  Text(
                                      "Voici la reponse a la question 3 qui peut être modifier par la suite")
                                ],
                              ),
                            ),
                            _buildDivider(),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                textColor: d_green,
                                childrenPadding: EdgeInsets.all(16),
                                title: Text(
                                    "Question 4 : Ceci est une questions qui peut être modifier par la suite"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                children: [
                                  Text(
                                      "Voici la reponse a la question 4 qui peut être modifier par la suite")
                                ],
                              ),
                            ),
                            _buildDivider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildFormContact(),
                ],
              ),
            ),
          ],
        ));
  }

/*
  - this function creates a little divider between the questions on the help page
*/
  Container _buildDivider() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade400);
  }

  Widget buildFormContact() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: <Widget>[
          Center(
              child: Text("Nous contacter",
                  style: TextStyle(color: Colors.black, fontSize: 24))),
          SizedBox(height: 8),
          buildLabelText('Motif'),
          buildDropDown(),
          SizedBox(height: 8),
          buildLabelText('Nom complet'),
          TextField(
              controller: nomController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Nom",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          buildLabelText('Email'),
          TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          buildLabelText('Message'),
          TextField(
              keyboardType: TextInputType.text,
              controller: messageController,
              maxLines: 7,
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
              decoration: InputDecoration(
                  errorText: wordsLimit ? null : '${this.nbWords}/450',
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Message",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: d_green,
              padding: EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async => {
              if (nomController.text == '')
                {showSnackBar(context, "Veuillez rentrer votre nom.")}
              else if (emailController.text == '')
                {showSnackBar(context, "Veuillez rentrer un email.")}
              else if (!EmailValidator.validate(emailController.text))
                {showSnackBar(context, "Veuillez rentrer un email valide.")}
              else if (messageController.text == '')
                {showSnackBar(context, "Veuillez écrire un message.")}
              else if (wordsLimit == false)
                {showSnackBar(context, "Nombre de character maximal dépassé.")}
              else if (nomController.text != '' &&
                  emailController != '' &&
                  messageController != '' &&
                  wordsLimit == true &&
                  EmailValidator.validate(emailController.text))
                {
                  // send(),
                  // Navigator.pop(context),
                  // Navigator.push(
                  //   context,
                  //   new MaterialPageRoute(
                  //       builder: (context) => new HelpScreen(
                  //             value: '',
                  //           )),
                  // ),

                  showSnackBar(context, "Les informations sont correctes."),
                  sendMail(value, messageController.text),
                }
              else
                {showSnackBar(context, 'Veuillez completer tous les champs.')},
            },
            child: Text(
              "Envoyer",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.2,
                color: Colors.white,
              ),
            ),
          ),
        ]));
  }

  sendMail(String subject, String message) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLauncherUri = Uri(
        scheme: 'mailto',
        path: 'example@domain.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'APP MOBILE: ${subject}',
          'body': '${message}',
        }));

    launch(emailLauncherUri.toString());
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

  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s, style: TextStyle(fontSize: 20)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget buildDropDown() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      width: MediaQuery.of(context).size.width * 0.94,
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
                child: Text(item,
                    style: TextStyle(
                      color: Colors.black,
                    )),
                value: item))
            .toList(),
        onChanged: (value) => setState(() {
          this.value = value!;
        }),
      )),
    );
  }
}
