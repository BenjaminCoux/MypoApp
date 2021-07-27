import 'package:mypo/model/alertkey.dart';

class Alert {
  String title;
  String content;
  final days;
  final cibles;
  bool active = false;
  List<AlertKey> keys;
  bool notification;

  Alert(
      {required this.title,
      required this.content,
      required this.days,
      required this.cibles,
      required this.notification,
      required this.keys});
}
