import 'package:hive/hive.dart';
import 'package:mypo/database/scheduledmsg_hive.dart';

class Boxes {
  static Box<Scheduledmsg_hive> getScheduledmsg() =>
      Hive.box<Scheduledmsg_hive>('scheduledmsg');
}
