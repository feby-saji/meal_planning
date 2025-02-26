// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_ce/hive.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';

part 'meal_plan_model.g.dart';

@HiveType(typeId: 4)
class MealPlanModel extends HiveObject {
  @HiveField(0)
  String? image;
  @HiveField(1)
  DateTime mealDate;
  @HiveField(2)
  RecipeModel recipe;
  @HiveField(3)
  MealPlanModel({
    this.image,
    required this.mealDate,
    required this.recipe,
  });
}
