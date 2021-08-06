import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/accueil_page.dart';
import 'package:mypo/pages/premium_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mypo/database/hive_database.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';

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
  final contryCodeController = TextEditingController();
  String pathOfImage = '';
  String numero = '';
  String code = '';
  String isoCode = '';
  bool fieldsChanged = false;
  final numeroExpression =
      RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

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
      numero = user.phoneNumber;

      imageController.text = user.imagePath;
      contryCodeController.text = user.contryCode;
      code = user.contryCode;
      isoCode = user.isoCode;
    } else {
      user = User_hive()
        ..name = ''
        ..email = ''
        ..phoneNumber = ''
        ..contryCode = ''
        ..isoCode = ''
        ..imagePath = "https://picsum.photos/id/1005/200/300";
      final box = Boxes.getUser();
      box.add(user);
      nomController.text = user.name;
      emailController.text = user.email;
      numeroController.text = user.phoneNumber;
      imageController.text = user.imagePath;
      contryCodeController.text = user.contryCode;
      isoCode = user.isoCode;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomController.dispose();
    emailController.dispose();
    numeroController.dispose();
    contryCodeController.dispose();
    super.dispose();
  }

  saveUserToHive(User_hive? User) {
    if (nomController.text != '' &&
        emailController != '' &&
        numeroController != '') {
      final user = User_hive()
        ..name = nomController.text
        ..email = emailController.text
        ..phoneNumber = numero
        ..contryCode = code
        ..isoCode = isoCode
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
        ..contryCode = ''
        ..isoCode = ''
        ..imagePath = "https://picsum.photos/id/1005/200/300";
      final box = Boxes.getUser();
      box.add(user);
    }

    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar:
              TopBarRedirection(title: "Edit profile", page: () => HomePage()),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
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
                        setState(() {
                          imageController.text = newImage.path;
                          fieldsChanged = true;
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    } else {
                      showSnackBar(context,
                          "Veuillez activer les permissions d'accès aux photos");
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Center(child: buildUpgradeButton()),
                const SizedBox(
                  height: 10,
                ),
                buildTextField('Nom', userDefined ? user!.name : "Example",
                    nomController, 1, TextInputType.text),
                buildTextField(
                    'Email',
                    userDefined ? user!.email : "Example@example.com",
                    emailController,
                    1,
                    TextInputType.emailAddress),
                // buildTextFieldNumero(
                //     'Téléphone',
                //     userDefined ? user!.phoneNumber : "06060606",
                //     numeroController,
                //     1),
                buildLabelText('Téléphone'),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IntlPhoneField(
                    searchText: 'Recherche par nom de pays',
                    controller: numeroController,
                    initialCountryCode: isoCode != '' ? isoCode : 'FR',
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: d_green,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        )),
                    onChanged: (phone) {
                      fieldsChanged = true;
                      numero = phone.number!;
                      code = phone.countryCode!;
                      isoCode = phone.countryISOCode!;
                      // print(phone.countryISOCode);
                      // print(phone.number);
                      // print('${phone.countryCode}${numeroController.text}');
                      // print(numeroTelephone);
                      // print(phone.completeNumber);
                    },
                    onCountryChanged: (phone) {
                      fieldsChanged = true;
                      isoCode = phone.countryISOCode!;
                      code = phone.countryCode!;
                      // print(phone.countryISOCode);
                      // print('Country code changed to: ' + phone.countryCode!);
                    },
                    onSubmitted: (phone) {},
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
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
                          } else if (!EmailValidator.validate(
                              emailController.text)) {
                            showSnackBar(
                                context, "Veuillez rentrer un email valide.");
                          } else if (numeroController.text == '') {
                            showSnackBar(
                                context, "Veuillez rentrer un numéro.");
                          } else if (!numeroExpression
                              .hasMatch(numeroController.text)) {
                            showSnackBar(
                                context, "Veuillez rentrer un numéro valide.");
                          } else if (!fieldsChanged) {
                          } else if (nomController.text != '' &&
                              emailController.text != '' &&
                              numeroController.text != '' &&
                              fieldsChanged &&
                              EmailValidator.validate(emailController.text)) {
                            saveUserToHive(user);
                            Navigator.pop(
                              context,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new EditProfilePage()));
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
            if (fieldsChanged) {
              setState(() {
                userDefined ? '' : user.imagePath = profileImagePath;
              });
              Navigator.pop(this.context);
              Navigator.pop(this.context);
              Navigator.push(
                this.context,
                new MaterialPageRoute(
                    builder: (context) => new EditProfilePage()),
              );
            } else {
              Navigator.pop(this.context);
            }
          },
          child: const Text('Oui', style: TextStyle(color: Colors.black)),
        ),
        new TextButton(
          onPressed: () {
            Navigator.pop(this.context);
          },
          child: const Text('Non', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildUpgradeButton() => ButtonWidget(
        text: "Upgrade to Premium",
        onClicked: () => {
          Navigator.pop(this.context),
          Navigator.push(this.context,
              new MaterialPageRoute(builder: (context) => new PremiumPage()))
        },
      );
  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s, style: TextStyle(fontSize: 20)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      TextEditingController controller,
      int nbLines,
      TextInputType keyboardType) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 3, 5, 0),
          child: Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                  fieldsChanged = true;
                })
              },
              minLines: 1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLines: nbLines,
              keyboardType: keyboardType,
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
          margin: EdgeInsets.fromLTRB(16, 3, 5, 0),
          child: Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                  fieldsChanged = true;
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
