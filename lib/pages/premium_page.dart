import 'package:flutter/material.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/logo_widget.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: TopBarPremium(title: "Premium"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey.shade800, Colors.grey.shade600])),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LogoPremium(),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Profitez sans limites du mode Premium',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: <Widget>[
                  ListTile(
                      title: Text("Supprimmer les publicités",
                          style: TextStyle(color: Colors.orange.shade300)),
                      trailing: Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                      )),
                  ListTile(
                      title: Text("Fonctionnalités illimitées",
                          style: TextStyle(color: Colors.orange.shade300)),
                      trailing: Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                      )),
                  ListTile(
                      title: Text("Statistiques hors connexion",
                          style: TextStyle(color: Colors.orange.shade300)),
                      trailing: Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                      )),
                  ListTile(
                      title: Text("Sauvegarder et restaurer",
                          style: TextStyle(color: Colors.orange.shade300)),
                      trailing: Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 16),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: d_green,
                          padding: const EdgeInsets.symmetric(horizontal: 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () => {},
                      child: Text(
                        "S'abonner maintenant",
                        style: TextStyle(
                            backgroundColor: d_green,
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'calibri'),
                      )),
                  Center(
                      child: Text("6,99 € / mois sans engagement",
                          style: TextStyle(color: Colors.white)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
