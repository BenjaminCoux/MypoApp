import 'package:flutter/material.dart';
import 'package:mypo/alerte.dart';

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
    final img = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
            image: img,
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
        child: Icon(
          isEdit ? Icons.add_a_photo : Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ));

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
