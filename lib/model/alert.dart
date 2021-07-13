import 'package:mypo/model/alertkey.dart';

enum Type { whatsapp, message, messenger }

class Alert {
  Type type;
  String title;
  String content;
  final days;
  final cibles;
  bool active = false;
  List<AlertKey> keys;

  Alert(
      {required this.title,
      required this.content,
      required this.type,
      required this.days,
      required this.cibles,
      required this.keys});
}
