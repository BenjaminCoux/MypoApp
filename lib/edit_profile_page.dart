import 'package:flutter/material.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/utils/user_preferences.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:mypo/widget/textfield_widget.dart';

import 'homepage.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
            const SizedBox(
              height: 24,
            ),
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(
              label: 'Nom',
              text: user.name,
              onChanged: (name) {},
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) {},
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(
              label: 'Numero',
              text: user.phoneNumber,
              onChanged: (phoneNumber) {},
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(
              label: 'About',
              text: user.about,
              onChanged: (about) {},
            ),
          ],
        ));
  }
}
