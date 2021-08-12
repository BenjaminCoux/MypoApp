import 'package:flutter/material.dart';

class Fonctions {}

void showSnackBar(BuildContext context, String s) {
  final snackBar = SnackBar(
    content: Text(s, style: TextStyle(fontSize: 20)),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
