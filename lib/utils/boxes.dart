import 'package:hive/hive.dart';
import 'package:mypo/database/hive_database.dart';

class Boxes {
  static Box<Scheduledmsg_hive> getScheduledmsg() =>
      Hive.box<Scheduledmsg_hive>('scheduledmsg');

  static Box<Rapportmsg_hive> getRapportmsg() =>
      Hive.box<Rapportmsg_hive>('rapportmsg');

  static Box<User_hive> getUser() => Hive.box<User_hive>('user');
}
