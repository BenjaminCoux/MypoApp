import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profile_page.dart';
import 'package:mypo/database/hive_database.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool hasChanged = false;
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final numeroController = TextEditingController();
  final imageController = TextEditingController();
  String pathOfImage = '';
  @override
  void initState() {
    super.initState();
    User_hive? user;
    List users = Boxes.getUser().values.toList().cast<User_hive>();
    if (!users.isEmpty) {
      user = users[0];
      nomController.text = user!.name;
      emailController.text = user.email;
      numeroController.text = user.phoneNumber;
      imageController.text = user.imagePath;
    } else {
      user = User_hive()
        ..name = ''
        ..email = ''
        ..phoneNumber = ''
        ..imagePath = "https://picsum.photos/id/1005/200/300";
      final box = Boxes.getUser();
      box.add(user);
      nomController.text = user.name;
      emailController.text = user.email;
      numeroController.text = user.phoneNumber;
      imageController.text = user.imagePath;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomController.dispose();
    emailController.dispose();
    numeroController.dispose();
    super.dispose();
  }

  saveUserToHive(User_hive? User) {
    if (nomController.text != '' &&
        emailController != '' &&
        numeroController != '') {
      final user = User_hive()
        ..name = nomController.text
        ..email = emailController.text
        ..phoneNumber = numeroController.text
        ..imagePath = imageController.text;

      final box = Boxes.getUser();
      if (box.isEmpty) {
        box.add(user);
      } else {
        box.put(0, user);
      }
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  final profileImagePath = "https://picsum.photos/id/1005/200/300";

  @override
  Widget build(BuildContext context) {
    bool userDefined = false;
    User_hive? user;
    List users = Boxes.getUser().values.toList().cast<User_hive>();
    if (!users.isEmpty) {
      userDefined = true;
      user = users[0];
    } else {
      user = User_hive()
        ..name = ''
        ..email = ''
        ..phoneNumber = ''
        ..imagePath = "https://picsum.photos/id/1005/200/300";
      final box = Boxes.getUser();
      box.add(user);
    }

    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: TopBarNoRedirection(title: "Edit profile"),
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
                  imagePath:
                      userDefined ? imageController.text : profileImagePath,
                  isEdit: true,
                  onClicked: () async {
                    if (await Permission.photos.request().isGranted) {
                      try {
                        final image = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        if (image == null) return;
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final name = basename(image.path);
                        final imageFile = File('${directory.path}/${name}');
                        final newImage =
                            await File(image.path).copy(imageFile.path);
                        // setState(() => pathOfImage = newImage.path);
                        setState(() => imageController.text = newImage.path);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    } else {
                      showSnackBar(context,
                          "Veuillez activer les permissions d'accès aux photos");
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                buildTextField('Nom', userDefined ? user!.name : "Example",
                    nomController, 1),
                buildTextField(
                    'Email',
                    userDefined ? user!.email : "Example@example.com",
                    emailController,
                    1),
                buildTextFieldNumero(
                    'Téléphone',
                    userDefined ? user!.phoneNumber : "06060606",
                    numeroController,
                    1),
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
                        onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  buildPopupDialogCancel(user!, userDefined))
                        },
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
                          if (nomController.text == '') {
                            showSnackBar(context, "Veuillez rentrer un nom.");
                          } else if (emailController.text == '') {
                            showSnackBar(context, "Veuillez rentrer un email.");
                          } else if (numeroController.text == '') {
                            showSnackBar(
                                context, "Veuillez rentrer un numéro.");
                          } else if (nomController.text != '' &&
                              emailController.text != '' &&
                              numeroController.text != '') {
                            saveUserToHive(user);
                            Navigator.of(context).pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          } else {
                            showSnackBar(
                                context, 'Veuillez completer tous les champs');
                          }
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
          )),
    );
  }

  buildPopupDialogCancel(User_hive user, bool userDefined) {
    return new AlertDialog(
      title: Text("Voulez vous annuler ?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            setState(() {
              userDefined ? '' : user.imagePath = profileImagePath;
            });
            Navigator.pop(this.context);
            Navigator.push(
              this.context,
              new MaterialPageRoute(builder: (context) => new ProfilePage()),
            );
          },
          child: const Text('Oui', style: TextStyle(color: Colors.black)),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(this.context).pop();
          },
          child: const Text('Non', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s, style: TextStyle(fontSize: 20)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
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
                // hintText: placeholder,
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

  Widget buildTextFieldNumero(String labelText, String placeholder,
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
              keyboardType: TextInputType.phone,
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
                // hintText: placeholder,
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
