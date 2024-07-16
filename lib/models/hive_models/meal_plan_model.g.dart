// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealPlanModelAdapter extends TypeAdapter<MealPlanModel> {
  @override
  final int typeId = 4;

  @override
  MealPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanModel(
      image: fields[0] as String?,
      mealDate: fields[1] as DateTime,
      recipe: fields[2] as RecipeModel,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.mealDate)
      ..writeByte(2)
      ..write(obj.recipe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
