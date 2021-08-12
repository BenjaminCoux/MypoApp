import 'package:flutter/material.dart';

Container textField(
    String placeholder, TextEditingController controller, int nbLines) {
  return Container(
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
        onChanged: (String value) => {},
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
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
