import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/prompt.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/prompt_function.dart';
import 'package:meal_planning/screens/recipe/detailed_recipe.dart';
import 'package:meal_planning/widgets/error_snackbar.dart';
import 'package:meta/meta.dart';

part 'generate_recipe_event.dart';
part 'generate_recipe_state.dart';

class GenerateRecipeBloc
    extends Bloc<GenerateRecipeEvent, GenerateRecipeState> {
  GenerateRecipeBloc()
      : super(GenerateRecipeState(
            prompt: PromptModel(
          images: [],
          dietaryRestrictions: [],
          stapleIngredients: [],
        ))) {
    on<UpdateImageEvent>(_updateImageEvent);
    on<UpdateCuisineEvent>(_updateCuisineEvent);
    on<UpdateDietaryRestrictionsEvent>(_updateDietaryRestrictionsEvent);
    on<UpdateStapleIngredientsEvent>(_updateStapleIngredientsEvent);
    on<SubmitPromptEvent>(_submitPromptEvent);
    on<ResetPromptEvent>(_resetPromptEvent);
  }

  _updateImageEvent(UpdateImageEvent event, Emitter<GenerateRecipeState> emit) {
    print('/////// updating image event');
    PromptModel updatedPrompt = state.prompt;
    updatedPrompt.images.add(event.img);
    return emit(GenerateRecipeState(prompt: updatedPrompt));
  }

  _updateCuisineEvent(
      UpdateCuisineEvent event, Emitter<GenerateRecipeState> emit) {
    PromptModel updatedPrompt = state.prompt;
    updatedPrompt.cuisine = event.cuisine!;
    return emit(GenerateRecipeState(prompt: updatedPrompt));
  }

  _updateDietaryRestrictionsEvent(
      UpdateDietaryRestrictionsEvent event, Emitter<GenerateRecipeState> emit) {
    PromptModel updatedPrompt = state.prompt;
    if (updatedPrompt.dietaryRestrictions.contains(event.dietaryRestrictions)) {
      updatedPrompt.dietaryRestrictions
          .removeWhere((item) => item == event.dietaryRestrictions);
    } else {
      updatedPrompt.dietaryRestrictions.add(event.dietaryRestrictions);
    }
    return emit(GenerateRecipeState(prompt: updatedPrompt));
  }

  _updateStapleIngredientsEvent(
      UpdateStapleIngredientsEvent event, Emitter<GenerateRecipeState> emit) {
    PromptModel updatedPrompt = state.prompt;
    if (updatedPrompt.stapleIngredients.contains(event.stapleIngresient)) {
      updatedPrompt.stapleIngredients
          .removeWhere((item) => item == event.stapleIngresient);
    } else {
      updatedPrompt.stapleIngredients.add(event.stapleIngresient);
    }
    return emit(GenerateRecipeState(prompt: updatedPrompt));
  }

  _submitPromptEvent(
      SubmitPromptEvent event, Emitter<GenerateRecipeState> emit) async {
    var result = await Gemini().generateRecipe(state.prompt);
    if (result is RecipeModel) {
      Navigator.of(event.context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => DetailedRecipeScreen(
                  recipe: result,
                  showSaveIcon: true,
                  goToRecipeScrn: true,
                )),
      );
    } else {
      showErrorSnackbar(
          context: event.context, message: 'fetch failed! try again $result');

      Navigator.of(event.context).pop();
    }
  }

  _resetPromptEvent(ResetPromptEvent event, Emitter<GenerateRecipeState> emit) {
    PromptModel updatedPrompt = state.prompt
      ..additionalContext = ''
      ..cuisine = ''
      ..dietaryRestrictions = []
      ..stapleIngredients = []
      ..images = [];

    return emit(GenerateRecipeState(prompt: updatedPrompt));
  }
}
