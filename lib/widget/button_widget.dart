import 'package:flutter/material.dart';
import 'package:mypo/utils/couleurs.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontFamily: 'calibri', fontSize: 18),
            primary: d_green,
            onPrimary: Colors.white,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
        child: Text(text),
        onPressed: onClicked,
      );
}
