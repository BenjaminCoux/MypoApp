import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/pages/premium_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String data = '';
  @override
  void initState() {
    getDataFromFile('assets/log.txt');
    super.initState();
  }

  writeDataToFile(String path, String data) async {
    final file = await File(path);
    debugPrint(file.toString());
    file.writeAsStringSync(data, mode: FileMode.append);
  }

  getDataFromFile(String path) async {
    String responseText;
    responseText = await rootBundle.loadString(path);
    setState(() {
      data = responseText;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool userDefined = false;
    User_hive? user;
    List users = Boxes.getUser().values.toList().cast<User_hive>();
    if (!users.isEmpty) {
      userDefined = true;

      user = users[0];
      // debugPrint('User is defined  ${user!.name} ,  ${user.imagePath}');
    }
    final imgPath = "https://picsum.photos/id/1005/200/300";
    return new WillPopScope(
      child: Scaffold(
          appBar: TopBarRedirection(title: "Profile", page: () => HomePage()),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 15,
              ),
              ProfileWidget(
                imagePath: userDefined ? user!.imagePath : imgPath,
                onClicked: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              buildUserInfo(user, userDefined),
              const SizedBox(
                height: 24,
              ),
              Center(child: buildUpgradeButton()),
              const SizedBox(
                height: 24,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(data,
              //       style: TextStyle(fontSize: 25, color: Colors.black)),
              // ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       textStyle: TextStyle(fontFamily: 'calibri', fontSize: 18),
              //       primary: d_green,
              //       onPrimary: Colors.white,
              //       shape: StadiumBorder(),
              //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 9)),
              //   child: Text('test'),
              //   onPressed: () {
              //     // writeDataToFile('assets/log.txt', 'test');
              //   },
              // )
            ],
          )),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget buildUserInfo(User_hive? user, bool userDefined) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildLabelText("Nom"),
          Container(
            margin: EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Text(
                    userDefined ? user!.name : "Example",
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          buildLabelText("Email"),
          Container(
            margin: EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Text(
                    userDefined ? '${user?.email} ' : "Example@example.com",
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          buildLabelText("Téléphone"),
          Container(
            margin: EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Text(
                    userDefined ? user!.phoneNumber : "0606060606",
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
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

  Widget buildUpgradeButton() => ButtonWidget(
        text: "Upgrade to Premium",
        onClicked: () => {
          Navigator.pop(context),
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new PremiumPage()))
        },
      );
}
