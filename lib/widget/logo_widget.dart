import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/edit_profile_page.dart';

/*
    -that class creates the logo in the middle
*/
class Logo extends StatelessWidget {
  final String? imgPath;
  Logo({Key? key, required this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isImgSet = false;
    if (imgPath != null) {
      isImgSet = true;
    }

    return isImgSet
        ? Column(
            children: [buildImage(context)],
          )
        : Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(
                  color: d_grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/icon.png'),
                  )),
            ),
          );
  }

  buildImage(BuildContext context) {
    final img = imgPath!.contains('https://')
        ? NetworkImage(imgPath!)
        : FileImage(File(imgPath!));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
          height: MediaQuery.of(context).size.height * 0.24,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new EditProfilePage()));
            },
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.height * 0.25,
                  image: img as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}

class LogoPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          Colors.grey.shade800.withOpacity(0), BlendMode.srcOver),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                image: AssetImage('assets/images/icon.png'),
              )),
        ),
      ),
    );
  }
}
