import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'recipe_model.g.dart';

@HiveType(typeId: 2)
class RecipeModel {
  @HiveField(0)
  String img;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? servings;
  @HiveField(3)
  final String? carb;
  @HiveField(4)
  final String? cal;
  @HiveField(5)
  final String? protein;
  @HiveField(6)
  final String? fat;
  @HiveField(7)
  final String? toal;
  @HiveField(8)
  final String? prep;
  @HiveField(9)
  final String? cook;
  @HiveField(10)
  List? ingredients;
  @HiveField(11)
  List<String> steps;
  @HiveField(12)
  bool isFav;

  RecipeModel({
    required this.img,
    required this.title,
    this.servings,
    this.carb,
    this.cal,
    this.protein,
    this.fat,
    this.toal,
    this.prep,
    this.cook,
    this.ingredients,
    required this.steps,
    required this.isFav,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    List<dynamic>? instructionsInfo = map['recipeInstructions'];
    List<String> instructions = [];
    if (instructionsInfo != null) {
      for (var instruction in instructionsInfo) {
        String text = instruction['text'] as String;
        instructions.add(text);
      }
    }

    String removePt(String text) {
      return text.toLowerCase().replaceAll(RegExp(r'[pt]'), '');
    }

    return RecipeModel(
      img: map['image']['url'] as String,
      title: map['headline'] as String,
      servings: map['recipeYield'][0] as String,
      carb: map['nutrition']['carbohydrateContent'] as String,
      cal: map['nutrition']['calories'] as String,
      protein: map['nutrition']['proteinContent'] as String,
      fat: map['nutrition']['fatContent'] as String,
      toal: removePt(map['totalTime']),
      prep: removePt(map['prepTime']),
      cook: removePt(map['cookTime']),
      isFav: false,
      ingredients:
          List<String>.from((map['recipeIngredient'] as List<dynamic>)),
      steps: instructions,
    );
  }

  factory RecipeModel.fromJsonGemini(Map<String, dynamic> json) {
    return RecipeModel(
      img: '',
      title: json['title'],
      steps: List<String>.from(json['instructions']),
      isFav: false,
      servings: json['servings'],
      carb: json['carbohydrates'],
      protein: json['protein'],
      fat: json['fat'],
      prep: json['preparation_time'].toString(),
      cook: json['cook_time'].toString(),
      toal: json['total_cook_and_preparation_time'].toString(),
      ingredients: List<String>.from(json['ingredients']),
    );
  }
}
