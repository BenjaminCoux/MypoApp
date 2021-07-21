import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mypo/pages/home_page.dart';
import 'package:mypo/database/scheduledmsg_hive.dart';
import 'package:mypo/widget/boxes.dart';
import 'package:telephony/telephony.dart';

const d_green = Color(0xFFA6C800);
const d_gray = Color(0xFFBABABA);
const d_darkgray = Color(0xFF6C6C6C);
const d_lightgray = Color(0XFFFAFAFA);
// **************************************************************************
// This function is building the app
// **************************************************************************
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ScheduledmsghiveAdapter());

  // loading the <key,values> pair from the local storage into memory
  await Hive.openBox<Scheduledmsg_hive>('scheduledmsg');

  runApp(MyApp());
}

// **************************************************************************
// This class creates the app
// input :
// output : app with home page
// **************************************************************************
class MyApp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyApp> {
  // ignore: unused_field
  late Timer _timer;
  int i = 0;
  @override
  void initState() {
    super.initState();
    periodic();
    //refreshMessages();
  }

  // **************************************************************************
  // This function is repeated periodically accord to the duration set (5 seconds right now)
  // input :
  // output : send message under time conditions
  // **************************************************************************
  periodic() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // debugPrint("period : ${i}");
      i++;
      final messages =
          Boxes.getScheduledmsg().values.toList().cast<Scheduledmsg_hive>();

      messages
          .takeWhile((Scheduledmsg_hive
                  message) => /*   Condition to send message (Date.time.now > message.date && message.status != sent) */
              //TODO: create condition for repeat options (montly, weekly..)
              (DateTime.now().microsecondsSinceEpoch >=
                  message.date.microsecondsSinceEpoch) &&
              message.status != MessageStatus.SENT)
          .forEach((Scheduledmsg_hive message) {
        debugPrint("message : ${message.name} , status: ${message.status}");
        /*
            for each message verifying the condition we try to send a message and set the state to sent or failed if error
          */
        try {
          Telephony.instance
              .sendSms(to: message.phoneNumber, message: message.message);
          setState(() {
            message.status = MessageStatus.SENT;
          });
        } catch (err) {
          setState(() {
            message.status = MessageStatus.FAILED;
          });
          debugPrint(err.toString());
        }

        debugPrint(
            "message sent to: ${message.phoneNumber}.. status: ${message.status}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
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
      ),
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
