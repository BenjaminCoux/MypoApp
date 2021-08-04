import 'package:flutter/material.dart';
import 'package:mypo/model/couleurs.dart';
import 'package:mypo/pages/profile_page.dart';

/*
  -that class creates the top app bar widget
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

class TopBarRedirection extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget Function() page;
  Size get preferredSize => new Size.fromHeight(50);

  const TopBarRedirection({
    Key? key,
    required this.title,
    required this.page,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title, style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: d_green,
      leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            try {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => page()),
              );
            } catch (e) {
              debugPrint(e.toString());
            }
          }),
    );
  }
}

class TopBarPremium extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  Size get preferredSize => new Size.fromHeight(50);

  const TopBarPremium({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title, style: TextStyle(fontFamily: 'calibri')),
      centerTitle: true,
      backgroundColor: Colors.grey.shade600,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new ProfilePage()),
        ),
      ),
    );
  }
}
