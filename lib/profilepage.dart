import 'package:flutter/material.dart';
import 'package:mypo/edit_profile_page.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/utils/user_preferences.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';

import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: d_green,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
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
            buildAbout(user),
            const SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Widget buildUserInfo(User user) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(user.name,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
          const SizedBox(
            height: 4,
          ),
          Text("email : ${user.email}",
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: d_darkgray)),
          const SizedBox(
            height: 4,
          ),
          Text("number : ${user.phoneNumber}",
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: d_darkgray))
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
