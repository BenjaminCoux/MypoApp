import 'package:flutter/material.dart';
import 'package:mypo/widget/appbar_widget.dart';

import 'home_page.dart';

class HelpScreen extends StatelessWidget {
  final String value;
  HelpScreen({required this.value});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: "Aide"),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(18),
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
                  Center(
                    child: Text(
                      'Nous contacter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: d_darkgray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Numero :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: d_darkgray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: d_darkgray,
                    ),
                  ),
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
}
