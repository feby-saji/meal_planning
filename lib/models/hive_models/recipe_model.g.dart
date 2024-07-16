// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 2;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      img: fields[0] as String,
      title: fields[1] as String,
      servings: fields[2] as String?,
      carb: fields[3] as String?,
      cal: fields[4] as String?,
      protein: fields[5] as String?,
      fat: fields[6] as String?,
      toal: fields[7] as String?,
      prep: fields[8] as String?,
      cook: fields[9] as String?,
      ingredients: (fields[10] as List?)?.cast<dynamic>(),
      steps: (fields[11] as List).cast<String>(),
      isFav: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.img)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.servings)
      ..writeByte(3)
      ..write(obj.carb)
      ..writeByte(4)
      ..write(obj.cal)
      ..writeByte(5)
      ..write(obj.protein)
      ..writeByte(6)
      ..write(obj.fat)
      ..writeByte(7)
      ..write(obj.toal)
      ..writeByte(8)
      ..write(obj.prep)
      ..writeByte(9)
      ..write(obj.cook)
      ..writeByte(10)
      ..write(obj.ingredients)
      ..writeByte(11)
      ..write(obj.steps)
      ..writeByte(12)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
