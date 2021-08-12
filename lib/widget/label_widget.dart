import 'package:flutter/material.dart';

class buildLabelText extends StatelessWidget {
  final String input;
  const buildLabelText({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
