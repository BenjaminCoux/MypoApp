import 'package:hive/hive.dart';

part 'hive_database.g.dart';

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
  @HiveField(8)
  late DateTime dateOfCreation;
}

@HiveType(typeId: 1)
class Rapportmsg_hive extends HiveObject {
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
  late String type;
  //TODO: field pour msg programme et message auto
}

@HiveType(typeId: 2)
class User_hive extends HiveObject {
  //extending to hiveobject we can use hive methods such as save delete etc.
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String email;
  @HiveField(2)
  late String phoneNumber;
  @HiveField(3)
  late String imagePath;
}

@HiveType(typeId: 3)
class GroupContact extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late List<String> numbers;
}

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

@HiveType(typeId: 5)
class AlertKey extends HiveObject {
  @HiveField(1)
  late final String name;
  @HiveField(2)
  late int contient;
  @HiveField(3)
  late bool allow;

  @override
  String toString() {
    return '{"name":"$name","contient":$contient,"allow":"$allow"}';
  }
}
