import 'package:flutter/material.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/utils/user_preferences.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:mypo/widget/textfield_widget.dart';

import 'home_page.dart';
import 'profile_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool hasChanged = false;
  @override
  Widget build(BuildContext context) {
    User user = UserPreferences.myUser;

    return Scaffold(
        appBar: TopBar(title: "Edit profile"),
        body: GestureDetector(
          onTap: () {
            //FocusScope.of(context).unfocus();
          },
          child: ListView(
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
                onChanged: (name) => user = user.copy(name: name),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                label: 'Email',
                text: user.email,
                onChanged: (email) => user = user.copy(email: email),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                label: 'Numero',
                text: user.phoneNumber,
                onChanged: (phoneNumber) =>
                    user = user.copy(phoneNumber: phoneNumber),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                label: 'About',
                maxLines: 4,
                text: user.about,
                onChanged: (about) => user = user.copy(about: about),
              ),
              Container(
                padding: EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProfilePage()),
                      ),
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: d_green,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // UserPreferences.setUser(user);
                        Navigator.of(context).pop(context);
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
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
