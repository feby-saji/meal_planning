import 'package:hive_flutter/adapters.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/models/hive_models/meal_plan_model.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String uid;
  @HiveField(1)
  bool isLoggedIn;
  @HiveField(2)
  String name;
  @HiveField(3)
  List<RecipeModel> recipes;
  @HiveField(4)
  List<RecipeModel> favRecipes;
  @HiveField(5)
  List<ShopingListItem> shoppingListItems;
  @HiveField(6)
  List<MealPlanModel> plannedMeals;
  @HiveField(7)
  bool isPremiumUser;
  @HiveField(8)
  Family? family;

  UserModel({
    required this.uid,
    required this.isLoggedIn,
    required this.name,
    required this.recipes,
    required this.favRecipes,
    required this.shoppingListItems,
    required this.plannedMeals,
    required this.isPremiumUser,
    this.family,
  });
}


