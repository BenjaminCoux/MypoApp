import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypo/database/hive_database.dart';
import 'package:mypo/model/user.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/pages/premium_page.dart';
import 'package:mypo/utils/boxes.dart';
import 'package:mypo/widget/appbar_widget.dart';
import 'package:mypo/widget/button_widget.dart';
import 'package:mypo/widget/profile_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // final box = Boxes.getUser();
    // final user = User_hive()
    //   ..firstname = ''
    //   ..name = ''
    //   ..phoneNumber = ''
    //   ..email = ''
    //   ..imagePath = 'https://picsum.photos/id/1005/200/300';
    // box.add(user);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  getPath() async {
    await getImageFileFromAssets('images/profile.jpg').then((value) {
      return value.path;
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
      //debugPrint('User is defined ${user!.imagePath}');
    }
    final imgPath = "https://picsum.photos/id/1005/200/300";
    return Scaffold(
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
                // debugPrint(user!.imagePath);
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
          ],
        ));
  }

  Widget buildUserInfo(User_hive? user, bool userDefined) => Column(
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
                    userDefined ? user!.name : "Example",
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(16, 5, 5, 5),
          //   child: Padding(
          //       padding: EdgeInsets.all(0),
          //       child: Row(
          //         children: [
          //           Text(
          //             "Prenom",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //                 color: Colors.black),
          //           )
          //         ],
          //       )),
          // ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(12, 10, 10, 10),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(18),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Container(
          //         padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          //         child: Text(
          //           userDefined ? user!.firstname : "Example",
          //           style: TextStyle(fontSize: 16),
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                    userDefined ? user!.email : "Example@example.com",
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

  Widget buildUpgradeButton() => ButtonWidget(
        text: "Upgrade to Premium",
        onClicked: () => {
          Navigator.pop(context),
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new PremiumPage()))
        },
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
