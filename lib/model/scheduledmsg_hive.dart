import 'package:hive/hive.dart';

part 'scheduledmsg_hive.g.dart';

@HiveType(typeId: 0)
class Scheduledmsg_hive extends HiveObject {
  //extending to hiveobject we can use hive methods such as save delete etc.
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String phoneNumber;
  @HiveField(2)
  late String message;
  @HiveField(3)
  late DateTime date;
  @HiveField(4)
  late String repeat;
  @HiveField(5)
  late bool countdown;
  @HiveField(6)
  late bool confirm;
  @HiveField(7)
  late bool notification;
}
