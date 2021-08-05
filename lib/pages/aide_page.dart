import 'package:flutter/material.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/widget/appbar_widget.dart';

// import 'home_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          TextField(
              controller: nomController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Nom",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          TextField(
              controller: emailController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
                  border: InputBorder.none)),
          SizedBox(height: 8),
          TextField(
              controller: messageController,
              maxLines: 7,
              decoration: InputDecoration(
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
                {showSnackBar(context, "Veuillez rentrer un nom à l'alerte.")}
              else if (emailController.text == '')
                {showSnackBar(context, "Veuillez rentrer un email valide.")}
              else if (messageController.text == '')
                {showSnackBar(context, "Veuillez écrire un message.")}
              else if (nomController.text != '' &&
                  emailController != '' &&
                  messageController != '')
                {
                  Navigator.pop(context),
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HelpScreen(
                              value: '',
                            )),
                  )
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

  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s, style: TextStyle(fontSize: 20)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
