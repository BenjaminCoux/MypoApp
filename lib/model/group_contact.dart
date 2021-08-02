import 'package:hive/hive.dart';

part 'group_contact.g.dart';

@HiveType(typeId: 3)
class GroupContact extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late List<String> numbers;
}
