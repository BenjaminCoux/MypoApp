import 'package:flutter/material.dart';

import 'package:mypo/pages/home_page.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mypo',
      home: HomePage(),
    );
  }
}
