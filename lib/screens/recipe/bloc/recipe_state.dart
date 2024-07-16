part of 'recipe_bloc.dart';

sealed class RecipeState {}

final class RecipeInitial extends RecipeState {}


final class RecipeLoadingState extends RecipeState {}

final class NoInternetRecipeState extends RecipeState {
  String err;
  NoInternetRecipeState({this.err = 'no internet connection'});
}


final class RecipeLoadSuccessState extends RecipeState {
  @override
  List<RecipeModel> recipes;
  RecipeLoadSuccessState({required this.recipes});
}

final class RecipeFetchingFailedState extends RecipeState {
  String err;
  RecipeFetchingFailedState({required this.err});
}

final class RecipeLoadFailedState extends RecipeState {
  String err;
  RecipeLoadFailedState({required this.err});
}
