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
