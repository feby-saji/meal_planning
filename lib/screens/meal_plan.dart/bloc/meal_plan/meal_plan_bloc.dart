import 'package:bloc/bloc.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/models/hive_models/meal_plan_model.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meta/meta.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  List<MealPlanModel> _cachedMealPlans = [];

  MealPlanBloc() : super(MealPlanInitial()) {
    on<AddMealToPlanEvent>(_addMealToPlanEvent);
    on<GetAllMealToPlanEvent>(_getAllMealToPlanEvent);
    on<DeleteMealPlanEvent>(_deleteMealPlanEvent);
  }

  _addMealToPlanEvent(
    AddMealToPlanEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    await HiveDb.addMealToPlan(event.meal);
    // _cachedMealPlans.add(event.meal);
    emit(MealPlanLoadSuccess(meals: _cachedMealPlans));
  }

  _getAllMealToPlanEvent(
    GetAllMealToPlanEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    List<MealPlanModel>? demoList = await HiveDb.getAllMealPlans();

    if (demoList != null) {
      _cachedMealPlans = demoList;
      if (_cachedMealPlans.isNotEmpty) {
        emit(MealPlanLoadSuccess(meals: _cachedMealPlans));
      } else {
        MealPlanFailureState(err: 'no meals');
      }
    }
  }

  _deleteMealPlanEvent(
      DeleteMealPlanEvent event, Emitter<MealPlanState> emit) async {
    await HiveDb.deleteMealplans(event.mealPlan);
    _cachedMealPlans.removeWhere((recipe) => recipe == event.mealPlan);

    if (_cachedMealPlans.isNotEmpty) {
      emit(MealPlanLoadSuccess(meals: _cachedMealPlans));
    } else {
      MealPlanFailureState(err: 'no meals');
    }
  }
}
