part of 'meal_search_bloc.dart';


@immutable

sealed class MealPlanSearchState {}


final class MealPlanSearchInitial extends MealPlanSearchState {}


final class MealPlanSearchFailureState extends MealPlanSearchState {

  String err;

  MealPlanSearchFailureState({required this.err});

}


final class MealPlanSearchResultsState extends MealPlanSearchState {

  List<RecipeModel> recipes;


  MealPlanSearchResultsState({required this.recipes});

}

