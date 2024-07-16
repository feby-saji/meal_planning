part of 'meal_plan_bloc.dart';

@immutable
sealed class MealPlanEvent {}

class AddMealToPlanEvent extends MealPlanEvent {
  final MealPlanModel meal;
  AddMealToPlanEvent({
    required this.meal,
  });
}

class DeleteMealPlanEvent extends MealPlanEvent {
  final MealPlanModel mealPlan;
  DeleteMealPlanEvent({required this.mealPlan});
  
}

class GetAllMealToPlanEvent extends MealPlanEvent {
  // DateTime date;
  // GetAllMealToPlanEvent({
  //   required this.date,
  // });
}
