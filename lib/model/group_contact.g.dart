// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
