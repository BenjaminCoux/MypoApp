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

  int time_till_next_send = -1;

  set_Time_till_next_send() {
    if (time_till_next_send != -1) {
      return;
    }
    final repeatOptions = [
      'Toutes les heures',
      'Tous les jours',
      'Toutes les semaines',
      'Tous les mois',
      'Tous les ans'
    ];
    if (this.repeat == repeatOptions[0]) {
      if (this.date.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        this.time_till_next_send = this.date.millisecondsSinceEpoch + 3600000;
      } else {
        this.time_till_next_send =
            DateTime.now().millisecondsSinceEpoch + 3600000;
      }
    } else if (this.repeat == repeatOptions[1]) {
      if (this.date.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        this.time_till_next_send =
            this.date.millisecondsSinceEpoch + 24 * 3600000;
      } else {
        this.time_till_next_send =
            DateTime.now().millisecondsSinceEpoch + 24 * 3600000;
      }
    } else if (this.repeat == repeatOptions[2]) {
      if (this.date.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        this.time_till_next_send =
            this.date.millisecondsSinceEpoch + 168 * 3600000;
      } else {
        this.time_till_next_send =
            DateTime.now().millisecondsSinceEpoch + 168 * (3600000);
      }
    } else if (this.repeat == repeatOptions[3]) {
      if (this.date.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        this.time_till_next_send =
            this.date.millisecondsSinceEpoch + 4 * 168 * 3600000;
      } else {
        this.time_till_next_send =
            DateTime.now().millisecondsSinceEpoch + 4 * 168 * 3600000;
      }
    } else {
      if (this.date.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        this.time_till_next_send =
            this.date.millisecondsSinceEpoch + 365 * 24 * 3600000;
      } else {
        this.time_till_next_send =
            DateTime.now().millisecondsSinceEpoch + 365 * 24 * 3600000;
      }
    }
  }
}

enum MessageStatus { PENDING, SENT, FAILED }


//TODO: maybe use this ??? instead of Status and handle each case 
//enum MessageRepeatOptions {daily, weekly, montly, yearly}

// if (repeat == Tous les ans) message.repeatOption = MessageRepeatOptions.yearly

