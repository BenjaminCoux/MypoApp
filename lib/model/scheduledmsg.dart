final String tableScheduledmsg = 'scheduledmsg';

class ScheduledmsgFields {
  static final List<String> values = [
    //ad all fields
    id, phoneNumber, message, date, repeat, countdown, confirm, notification
  ];
  // all the fields are the column names in our db
  static final String id = '_id';
  static final String phoneNumber = 'phoneNumber';
  static final String message = 'message';
  static final String date = 'date';
  static final String repeat = 'repeat';
  static final String countdown = 'countdown';
  static final String confirm = 'confirm';
  static final String notification = 'notification';
}

class Scheduledmsg {
  final int? id;
  final String phoneNumber;
  final String message;
  final DateTime date;
  final String repeat;
  final bool countdown;
  final bool confirm;
  final bool notification;

  const Scheduledmsg(
      {this.id,
      required this.phoneNumber,
      required this.message,
      required this.date,
      required this.repeat,
      required this.countdown,
      required this.confirm,
      required this.notification});

  static Scheduledmsg fromJson(Map<String, Object?> json) => Scheduledmsg(
        id: json[ScheduledmsgFields.id] as int?,
        phoneNumber: json[ScheduledmsgFields.phoneNumber] as String,
        message: json[ScheduledmsgFields.message] as String,
        date: DateTime.parse(json[ScheduledmsgFields.date]
            as String), // converting back to DateTime object
        repeat: json[ScheduledmsgFields.repeat] as String,
        countdown:
            json[ScheduledmsgFields.countdown] == 1, // if == 1 true else false
        confirm: json[ScheduledmsgFields.confirm] == 1,
        notification: json[ScheduledmsgFields.notification] == 1,
      );

  Map<String, Object?> toJson() => {
        ScheduledmsgFields.id: id,
        ScheduledmsgFields.phoneNumber: phoneNumber,
        ScheduledmsgFields.message: message,
        ScheduledmsgFields.date:
            date.toIso8601String(), // datatime type must be converted to string
        ScheduledmsgFields.repeat: repeat,
        ScheduledmsgFields.countdown: countdown ? 1 : 0,
        ScheduledmsgFields.confirm: confirm ? 1 : 0,
        ScheduledmsgFields.notification: notification ? 1 : 0,
      };

  Scheduledmsg copy({
    // we give the values we want to modify otherwise we keeep the same value as before
    int? id,
    String? phoneNumber,
    String? message,
    DateTime? date,
    String? repeat,
    bool? countdown,
    bool? confirm,
    bool? notification,
  }) =>
      Scheduledmsg(
          id: id ?? this.id,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          message: message ?? this.message,
          date: date ?? this.date,
          repeat: repeat ?? this.repeat,
          countdown: countdown ?? this.countdown,
          confirm: confirm ?? this.confirm,
          notification: notification ?? this.notification);
}
