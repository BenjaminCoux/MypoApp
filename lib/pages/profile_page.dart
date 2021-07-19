import 'package:flutter/material.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/utils/user_preferences.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';

import 'edit_profile_page.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
        appBar: TopBar(title: "Profile"),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 15,
            ),
            ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
                setState(() {});
              },
            ),
            const SizedBox(
              height: 24,
            ),
            buildUserInfo(user),
            const SizedBox(
              height: 24,
            ),
            Center(child: buildUpgradeButton()),
            const SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Widget buildUserInfo(User user) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
            child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Text(
                      "Nom",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                )),
          ),
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
                    user.name,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
            child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Text(
                      "Prenom",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                )),
          ),
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
                    user.name,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
            child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                )),
          ),
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
                    user.email,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
            child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Text(
                      "Téléphone",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                )),
          ),
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
                    user.phoneNumber,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: "Upgrade to Premium",
        onClicked: () {},
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'calibri'),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user.about,
              style: TextStyle(fontSize: 20, height: 1.4),
            ),
          ],
        ),
      );
}
