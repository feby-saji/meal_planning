// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[0] as String,
      isLoggedIn: fields[1] as bool,
      name: fields[2] as String,
      recipes: (fields[3] as List).cast<RecipeModel>(),
      favRecipes: (fields[4] as List).cast<RecipeModel>(),
      shoppingListItems: (fields[5] as List).cast<ShopingListItem>(),
      plannedMeals: (fields[6] as List).cast<MealPlanModel>(),
      isPremiumUser: fields[7] as bool,
      family: fields[8] as Family?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.isLoggedIn)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.recipes)
      ..writeByte(4)
      ..write(obj.favRecipes)
      ..writeByte(5)
      ..write(obj.shoppingListItems)
      ..writeByte(6)
      ..write(obj.plannedMeals)
      ..writeByte(7)
      ..write(obj.isPremiumUser)
      ..writeByte(8)
      ..write(obj.family);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
