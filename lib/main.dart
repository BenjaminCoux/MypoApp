import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/model/scheduledmsg_hive.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ScheduledmsghiveAdapter());

  // loading the <key,values> pair from the local storage into memory
  await Hive.openBox<Scheduledmsg_hive>('scheduledmsg');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('de', 'DE'), // German
        const Locale('ar'),
        const Locale('hi'),
        const Locale('es'),
        const Locale('fr', 'FR'),
        // ... other locales the app supports
      ],
      debugShowCheckedModeBanner: false,
      title: 'mypo',
      home: HomePage(),
    );
  }
}

/*
cleaning the cache

flutter clean
flutter pub cache repair
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build

*/
