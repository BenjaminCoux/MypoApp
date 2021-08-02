import 'package:hive/hive.dart';
import 'package:mypo/model/alertkey.dart';
import 'package:mypo/model/group_contact.dart';

part 'alert.g.dart';

@HiveType(typeId: 4)
class Alert extends HiveObject {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String content;
  @HiveField(3)
  late final days;
  @HiveField(4)
  late final cibles;
  @HiveField(5)
  bool active = false;
  @HiveField(6)
  late List<AlertKey> keys;
  @HiveField(7)
  late bool notification;
  @HiveField(8)
  late List<GroupContact> groupcontats;
}
