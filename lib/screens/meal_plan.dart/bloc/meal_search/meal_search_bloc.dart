import 'package:bloc/bloc.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meta/meta.dart';
part 'meal_search_event.dart';
part 'meal_search_state.dart';

class MealPlanSearchBloc extends Bloc<MealPlanSearchEvent, MealPlanSearchState> {
  MealPlanSearchBloc() : super(MealPlanSearchInitial()) {
    on<MealPlanSerchEvent>(_mealPlanSearchEvent);
  }
  _mealPlanSearchEvent(
    MealPlanSerchEvent event,
    Emitter<MealPlanSearchState> emit,
  ) async {
    if (event.val.isEmpty) {
      List<RecipeModel>? recipes = await HiveDb.loadAllRecipes();
      if (recipes!= null && recipes.isNotEmpty) {
        emit(MealPlanSearchResultsState(recipes: recipes));
      }else{
        emit(MealPlanSearchFailureState(err: 'no recipe found'));
      }
    } else {
      List<RecipeModel> recipes = await HiveDb.getRecipes(event.val);
      if (recipes.isEmpty) {
        emit(MealPlanSearchFailureState(err: 'no recipe found'));
      } else {
        emit(MealPlanSearchResultsState(recipes: recipes));
      }
    }
  }
}

