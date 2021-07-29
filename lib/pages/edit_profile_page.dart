import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypo/model/colors.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/utils/user_preferences.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'profile_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool hasChanged = false;
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final numeroController = TextEditingController();
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
                height: 15,
              ),
              ProfileWidget(
                imagePath: user.imagePath,
                isEdit: true,
                onClicked: () async {
                  final image =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (image == null) return;
                  final directory = await getApplicationDocumentsDirectory();
                  final name = basename(image.path);
                  final imageFile = File('${directory.path}/${name}');
                  final newImage = await File(image.path).copy(imageFile.path);

                  setState(() => user = user.copy(imagePath: newImage.path));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              buildTextField('Prenom', user.name, prenomController, 1),
              buildTextField('Nom', user.name, nomController, 1),
              buildTextField('Email', user.email, emailController, 1),
              buildTextField(
                  'Téléphone', user.phoneNumber, numeroController, 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(12),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40),
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
                        "Annuler",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: d_green,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // UserPreferences.setUser(user);
                        Navigator.of(context).pop(context);
                      },
                      child: Text(
                        "Sauvegarder",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController controller, int nbLines) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
          child: Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  )
                ],
              )),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              controller: controller,
              onChanged: (String value) => {
                setState(() {
                  // set new state
                })
              },
              minLines: 1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLines: nbLines,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent)),
                contentPadding: EdgeInsets.all(8),
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
