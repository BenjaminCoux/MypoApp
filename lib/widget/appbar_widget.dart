import 'package:flutter/material.dart';
import 'package:mypo/pages/home_page.dart';

/*
  -that class creates the top app bad widget
*/

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  Size get preferredSize => new Size.fromHeight(50);

  const TopBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title, style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
    );
  }
}
