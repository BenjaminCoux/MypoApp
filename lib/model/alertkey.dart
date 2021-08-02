import 'package:hive/hive.dart';

part 'alertkey.g.dart';

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
