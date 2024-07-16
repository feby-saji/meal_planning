// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoppinglist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopingListItemAdapter extends TypeAdapter<ShopingListItem> {
  @override
  final int typeId = 3;

  @override
  ShopingListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopingListItem(
      name: fields[0] as String,
      quantity: fields[2] as String,
      unit: fields[3] as String,
      category: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopingListItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopingListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
