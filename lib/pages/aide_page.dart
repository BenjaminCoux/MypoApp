import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/utils/couleurs.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/utils/fonctions.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/divider_widget.dart';
import 'package:mypo/widget/label_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// **************************************************************************
// This class creates the help page screen
// input :
// output : scaffold widget with the components/widgets of help page
// **************************************************************************

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
  static final List<String> motifs = <String>[
    'Remarques/Suggestions',
    'Questions/Informations'
  ];

  List<String> questions = [
    'Ceci est une questions qui peut être modifier par la suite',
    'Ceci est une questions qui peut être modifier par la suite'
  ];
  List<String> reponses = [
    'Voici la reponse a la question qui peut être modifier par la suite',
    'Voici la reponse a la question qui peut être modifier par la suite'
  ];
  String value = motifs.first;
  late final email;
  List<String> attachments = [];
  bool isHTML = false;
  int nbMaxWords = 450;
  bool wordsLimit = true;
  int nbWords = 0;
// **************************************************************************
// This function creates the home page screen
// input :
// output : column widget with the components/widgets of contact form page
// **************************************************************************

  Widget buildFormContact() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: <Widget>[
          Center(
              child: Text("Nous contacter",
                  style: TextStyle(color: Colors.black, fontSize: 24))),
          SizedBox(height: 8),
          buildLabelText(input: 'Motif'),
          buildDropDown(),
          SizedBox(height: 8),
          buildLabelText(input: 'Nom complet'),
          TextField(
              controller: nomController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Nom",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          buildLabelText(input: 'Email'),
          TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          buildLabelText(input: 'Message'),
          TextField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
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
                {showSnackBar(context, "Veuillez rentrer votre nom")}
              else if (emailController.text == '')
                {showSnackBar(context, "Veuillez rentrer un email")}
              else if (!EmailValidator.validate(emailController.text))
                {showSnackBar(context, "Veuillez rentrer un email valide")}
              else if (messageController.text == '')
                {showSnackBar(context, "Veuillez écrire un message")}
              else if (wordsLimit == false)
                {showSnackBar(context, "Nombre de caractère maximal dépassé")}
              else if (nomController.text != '' &&
                  emailController != '' &&
                  messageController != '' &&
                  wordsLimit == true &&
                  EmailValidator.validate(emailController.text))
                {
                  sendMail(value, messageController.text),
                }
              else
                {showSnackBar(context, 'Veuillez compléter tous les champs')},
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

// **************************************************************************
// This function sends email
// input : the subject and the message
// output : open the email application with filled content
// **************************************************************************

  sendMail(String subject, String message) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLauncherUri = Uri(
        scheme: 'mailto',
        path: 'contact@mypo.fr',
        query: encodeQueryParameters(<String, String>{
          'subject': 'APP MOBILE: ${subject}',
          'body': '${message}',
        }));

    launch(emailLauncherUri.toString());
  }

// **************************************************************************
// This function build the list of frequently asked questions and its answers
// input : the list of questions, the length of the list, the answers and the context
// output : build a list of questions wich expands to show the answer when clicked
// **************************************************************************
  myListAide(List<String> questions, int lenght, List<String> reponses,
      BuildContext context) {
    return lenght > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (BuildContext context, int index) {
              final question = questions[index];
              final reponse = reponses[index];
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: d_green,
                      childrenPadding: EdgeInsets.all(16),
                      title: Text("Question ${index + 1}: ${question}"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      children: [Text(reponse)],
                    ),
                  ),
                  buildDivider(),
                ],
              );
            })
        : const Text("Aucune question", style: TextStyle(fontSize: 24));
  }

// **************************************************************************
// This function build a drop down menu to show the reasons of contact
// input :
// output : drop down menu with different reasons
// **************************************************************************
  Widget buildDropDown() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      width: MediaQuery.of(context).size.width * 0.94,
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        value: value,
        items: motifs
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
                            myListAide(
                                questions, questions.length, reponses, context),
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
}
