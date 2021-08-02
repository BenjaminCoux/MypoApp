import 'dart:io';

import 'package:flutter/material.dart';

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
        : Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'))),
          );
  }

  buildImage(BuildContext context) {
    final img = imgPath!.contains('https://')
        ? NetworkImage(imgPath!)
        : FileImage(File(imgPath!));

    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Ink.image(
            image: img as ImageProvider,
            fit: BoxFit.cover,
            width: 250,
            height: 10,
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
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage('assets/images/logopremium.png'))),
        ));
  }
}
