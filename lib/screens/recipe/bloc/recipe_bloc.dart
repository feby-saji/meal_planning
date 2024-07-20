import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/repository/get_img.dart';
import 'package:meal_planning/repository/recipe_repo.dart';
import 'package:meal_planning/screens/family/widgets/snackbar.dart';

import '../../../functions/network_connection.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

bool isFavPage = false;

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeRepository recipeRepository;
  List<RecipeModel>? _cachedRecipes;
  bool seachForFav = false;

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<AddNewRecipeEvent>(_addRecipe);
    on<LoadRecipesEvent>(_loadRecipes);
    on<DeleteRecipeEvent>(_deleteRecipe);
    on<UpdateFavouriteEvent>(_updateFav);
    on<SortRecipesEvent>(_sortRecipes);
    on<SearchRecipesEvent>(_searchRecipes);
    on<SaveGeneratedRecipe>(_saveGeneratedRecipe);
  }

  _saveGeneratedRecipe(
      SaveGeneratedRecipe event, Emitter<RecipeState> emit) async {
    List<RecipeModel> recipes = await HiveDb.addNewRecipe(event.recipe);
    showCustomSnackbar(event.context, 'recipe saved');

    return emit(RecipeLoadSuccessState(recipes: recipes));
  }

  _deleteRecipe(DeleteRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoadingState());
    await HiveDb.deletRecipe(event.recipe);

    if (_cachedRecipes != null && _cachedRecipes!.isNotEmpty) {
      emit(RecipeLoadSuccessState(recipes: _cachedRecipes!));
    } else {
      _cachedRecipes = await HiveDb.loadAllRecipes();

      if (_cachedRecipes != null && _cachedRecipes!.isNotEmpty) {
        return emit(RecipeLoadSuccessState(recipes: _cachedRecipes!));
      } else {
        return emit(RecipeLoadFailedState(err: 'No recipes found'));
      }
    }
  }

  _loadRecipes(LoadRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoadingState());
    if (seachForFav) {
      add(SortRecipesEvent(fav: seachForFav));
    } else {
      // TODO!
      _cachedRecipes = await HiveDb.loadAllRecipes();

      if (_cachedRecipes != null && _cachedRecipes!.isNotEmpty) {
        return emit(RecipeLoadSuccessState(recipes: _cachedRecipes!));
      } else {
        return emit(RecipeLoadFailedState(err: 'No recipes found'));
      }
    }
  }

  _addRecipe(AddNewRecipeEvent event, Emitter<RecipeState> emit) async {
    if (await connectedToInternet()) {
      emit(RecipeLoadingState());
      dynamic result = await recipeRepository.getRecipeContent(event.url);

      if (result is RecipeModel) {
        // download and compress the image
        String? imgPath = await downloadCompressAndGetPath(result.img);

        if (imgPath != null) {
          result.img = imgPath;
          List<RecipeModel> recipes = await HiveDb.addNewRecipe(result);

          return emit(RecipeLoadSuccessState(recipes: recipes));
        } else {
          return emit(
              RecipeFetchingFailedState(err: 'failed to fetch. Try again'));
        }
      } else {
        return emit(RecipeFetchingFailedState(err: result));
      }
    } else {
      return emit(NoInternetRecipeState());
    }
  }

  _updateFav(UpdateFavouriteEvent event, Emitter<RecipeState> emit) async {
    List<RecipeModel> recipes;
    await HiveDb.updateFav(event.recipe, event.isFav);

    RecipeModel recipeToUpdate =
        _cachedRecipes!.firstWhere((element) => element == event.recipe);
    recipeToUpdate.isFav = event.isFav;

    if (isFavPage) {
      recipes = _cachedRecipes!
          .where((recipe) => recipe.isFav != event.isFav)
          .toList();

      emit(RecipeLoadSuccessState(recipes: recipes));
    } else {
      recipes = _cachedRecipes!.toList();
    }

    if (recipes.isNotEmpty) {
      emit(RecipeLoadSuccessState(recipes: recipes));
    } else {
      emit(RecipeLoadFailedState(err: 'no favourite recipes found'));
    }
  }

  _sortRecipes(SortRecipesEvent event, Emitter<RecipeState> emit) async {
    if (_cachedRecipes != null && event.fav == true) {
      seachForFav = event.fav;

      List<RecipeModel> recipes =
          _cachedRecipes!.where((recipe) => recipe.isFav == true).toList();

      if (recipes.isEmpty) {
        emit(RecipeLoadFailedState(err: 'no favourite recipes found'));
      } else {
        return emit(RecipeLoadSuccessState(recipes: recipes));
      }
    } else if (_cachedRecipes != null && event.fav == false) {
      seachForFav = event.fav;
      return emit(RecipeLoadSuccessState(recipes: _cachedRecipes!));
    }
  }

  _searchRecipes(SearchRecipesEvent event, Emitter<RecipeState> emit) async {
    if (event.val.isEmpty) {
      add(SortRecipesEvent(fav: seachForFav));
    } else {
      List<RecipeModel> recipes =
          await HiveDb.searchRecipes(event.val, seachForFav);

      if (recipes.isEmpty) {
        emit(RecipeLoadFailedState(err: 'no recipes found'));
      } else {
        emit(RecipeLoadSuccessState(recipes: recipes));
      }
    }
  }
}
