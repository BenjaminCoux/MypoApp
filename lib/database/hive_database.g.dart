// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledmsghiveAdapter extends TypeAdapter<Scheduledmsg_hive> {
  @override
  final int typeId = 0;

  @override
  Scheduledmsg_hive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scheduledmsg_hive()
      ..name = fields[0] as String
      ..phoneNumber = fields[1] as String
      ..message = fields[2] as String
      ..date = fields[3] as DateTime
      ..repeat = fields[4] as String
      ..countdown = fields[5] as bool
      ..confirm = fields[6] as bool
      ..notification = fields[7] as bool
      ..dateOfCreation = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Scheduledmsg_hive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.repeat)
      ..writeByte(5)
      ..write(obj.countdown)
      ..writeByte(6)
      ..write(obj.confirm)
      ..writeByte(7)
      ..write(obj.notification)
      ..writeByte(8)
      ..write(obj.dateOfCreation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledmsghiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RapportmsghiveAdapter extends TypeAdapter<Rapportmsg_hive> {
  @override
  final int typeId = 1;

  @override
  Rapportmsg_hive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rapportmsg_hive()
      ..name = fields[0] as String
      ..phoneNumber = fields[1] as String
      ..message = fields[2] as String
      ..date = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Rapportmsg_hive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RapportmsghiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserhiveAdapter extends TypeAdapter<User_hive> {
  @override
  final int typeId = 2;

  @override
  User_hive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User_hive()
      ..name = fields[0] as String
      ..email = fields[1] as String
      ..phoneNumber = fields[2] as String
      ..imagePath = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, User_hive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserhiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroupContactAdapter extends TypeAdapter<GroupContact> {
  @override
  final int typeId = 3;

  @override
  GroupContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupContact()
      ..name = fields[0] as String
      ..description = fields[1] as String
      ..numbers = (fields[2] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, GroupContact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.numbers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
