part of 'meal_search_bloc.dart';

@immutable
sealed class MealPlanSearchEvent {}

class MealPlanSerchEvent extends MealPlanSearchEvent {
  String val;
  MealPlanSerchEvent({
    required this.val,
  });
}