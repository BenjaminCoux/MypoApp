// import 'package:mypo/model/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertPreferences {
  // ignore: unused_field
  static late SharedPreferences _preferences;

  // ignore: unused_field
  static const _keyAlert = 'alert';

  // static Alert myAlert = Alert(
  //     title: 'title',
  //     content: 'content',
  //     days: [false, false, false, false, false, false, false],
  //     cibles: [false, false, false],
  //     keys: List.empty());

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
}
