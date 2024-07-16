part of 'meal_plan_bloc.dart';

@sealed
sealed class MealPlanState {}

final class MealPlanInitial extends MealPlanState {}

final class MealPlanLoadSuccess extends MealPlanState {
  List<MealPlanModel> meals;
  MealPlanLoadSuccess({required this.meals});
}

final class MealPlanFailureState extends MealPlanState {
  String err;
  MealPlanFailureState({required this.err});
}
