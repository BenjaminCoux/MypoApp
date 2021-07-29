import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mypo/model/colors.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = d_green;
    //Stack allows to overlap multiple widgets on top of eachother
    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(bottom: 0, right: 4, child: buildEditIcon(color))
      ]),
    );
  }

  Widget buildImage() {
    final img = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
            image: img as ImageProvider,
            fit: BoxFit.cover,
            width: 130,
            height: 130,
            child: InkWell(onTap: onClicked)),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
          color: color,
          all: 8,
          // child: Icon(
          //   isEdit ? Icons.add_a_photo : Icons.edit,
          //   color: Colors.white,
          //   size: 20,
          // ),
          child: SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              icon: isEdit
                  ? Icon(Icons.add_a_photo, size: 20)
                  : Icon(Icons.edit, size: 20),
              color: Colors.white,
              onPressed: onClicked,
            ),
          )));

  buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          color: color,
          padding: EdgeInsets.all(all),
          child: child,
        ),
      );
}
