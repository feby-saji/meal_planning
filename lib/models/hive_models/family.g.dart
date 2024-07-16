// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyAdapter extends TypeAdapter<Family> {
  @override
  final int typeId = 5;

  @override
  Family read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Family(
      familyId: fields[1] as String,
      creator: fields[2] as String,
      members: (fields[3] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Family obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.familyId)
      ..writeByte(2)
      ..write(obj.creator)
      ..writeByte(3)
      ..write(obj.members);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
