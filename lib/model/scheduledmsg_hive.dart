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
  @HiveField(8)
  late MessageStatus status = MessageStatus.PENDING;
}

enum MessageStatus { PENDING, SENT, FAILED }


//TODO: maybe use this ??? instead of Status and handle each case 
//enum MessageRepeatOptions {daily, weekly, montly, yearly}

// if (repeat == Tous les ans) message.repeatOption = MessageRepeatOptions.yearly

