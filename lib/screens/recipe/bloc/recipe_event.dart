// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_bloc.dart';

sealed class RecipeEvent {}

class LoadRecipesEvent extends RecipeEvent {}


class SearchRecipesEvent extends RecipeEvent {
  // bool fav;
  String val;
  SearchRecipesEvent({
    // required this.fav,
    required this.val,
  });
}

class SortRecipesEvent extends RecipeEvent {
  bool fav;
  SortRecipesEvent({
    required this.fav,
  });
}

class DeleteRecipeEvent extends RecipeEvent {
  RecipeModel recipe;
  DeleteRecipeEvent({required this.recipe});
}

class AddNewRecipeEvent extends RecipeEvent {
  String url;
  AddNewRecipeEvent({required this.url});
}

class UpdateFavouriteEvent extends RecipeEvent {
  RecipeModel recipe;
  bool isFav;
  UpdateFavouriteEvent({
    required this.isFav,
    required this.recipe,
  });
}
