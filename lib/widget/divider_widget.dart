import 'package:flutter/material.dart';

Container buildDivider() {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1,
      color: Colors.grey.shade400);
}

Container buildDividerTransparent() {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1,
      color: Colors.transparent);
}
