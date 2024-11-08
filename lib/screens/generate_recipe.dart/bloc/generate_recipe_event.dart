part of 'generate_recipe_bloc.dart';

@immutable
sealed class GenerateRecipeEvent {}

class UpdateImageEvent extends GenerateRecipeEvent {
  final  XFile img;
  UpdateImageEvent({required this.img});
}

class UpdateCuisineEvent extends GenerateRecipeEvent {
  final String? cuisine;
  UpdateCuisineEvent({this.cuisine});
}

class UpdateDietaryRestrictionsEvent extends GenerateRecipeEvent {
  String? dietaryRestrictions;
  UpdateDietaryRestrictionsEvent({this.dietaryRestrictions});
}

class UpdateStapleIngredientsEvent extends GenerateRecipeEvent {
  String? stapleIngresient;
  UpdateStapleIngredientsEvent({this.stapleIngresient});
}

class SubmitPromptEvent extends GenerateRecipeEvent {
  BuildContext context;
  SubmitPromptEvent({required this.context});
}

class ResetPromptEvent extends GenerateRecipeEvent {}
