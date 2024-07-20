import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/generate_recipe.dart/bloc/generate_recipe_bloc.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/functions.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/prompt_function.dart';
import 'package:meal_planning/utils/styles.dart';

class CreateRecipeScreen extends StatelessWidget {
  const CreateRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kClrAccent,
        title: const Text('Create a recipe'),
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/chef_rat.png'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('I have these ingredients:'),
            const SizedBox(height: 8),
            _buildImageAddingSection(context),
            //
            const SizedBox(height: 16),
            const Text('I have these ingredients:'),
            const SizedBox(height: 8),
            _buildStapleIngredients(),
            const SizedBox(height: 16),
            const Text("I'm in the mood for:"),
            const SizedBox(height: 8),
            _buildCuisineChips(),
            const SizedBox(height: 16),
            const Text('I have the following dietary restrictions:'),
            const SizedBox(height: 8),
            _buildDietaryRestrictionChips(),
            const SizedBox(height: 16),
            const Text('Add additional context...'),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.green.shade500, width: 2),
                ),
                filled: true,
                fillColor: Colors.green.shade50,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context
                      .read<GenerateRecipeBloc>()
                      .add(ResetPromptEvent()),
                  icon: Icon(
                    Icons.refresh,
                    color: kClrAccent,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 51, 60,
                        51), // Set your custom background color here
                  ),
                  label: Text(
                    'Reset fields',
                    style: TextStyle(color: kClrAccent),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => const Dialog(
                              backgroundColor: Colors.transparent,
                              child: Center(child: CircularProgressIndicator()),
                            ));
                    context
                        .read<GenerateRecipeBloc>()
                        .add(SubmitPromptEvent(context: context));
                  },
                  icon: Icon(
                    Icons.send,
                    color: kClrAccent,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 51, 60,
                        51), // Set your custom background color here
                  ),
                  label: Text(
                    'create Recipe',
                    style: TextStyle(color: kClrAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildImageAddingSection(BuildContext context) {
    return BlocBuilder<GenerateRecipeBloc, RecipeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            GestureDetector(
                onTap: () => pickImage(context),
                child: _buildImagePlaceholder(altImg: true)),
            ...state.prompt.images
                .map((img) => _buildImagePlaceholder(img: img))
                .toList()
          ]),
        );
      },
    );
  }

  Widget _buildImagePlaceholder({bool altImg = false, img}) {
    File? image;

    if (!altImg) {
      image = File(img.path);
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: altImg
          ? Icon(Icons.add_photo_alternate,
              size: 40, color: Colors.green.shade300)
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(image!)),
    );
  }

  Widget _buildStapleIngredients() {
    final staples = [
      'oil',
      'butter',
      'flour',
      'salt',
      'pepper',
      'sugar',
      'milk',
      'vinegar'
    ];
    return BlocBuilder<GenerateRecipeBloc, RecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: staples
              .map((staple) => ChoiceChip(
                    label: Text(staple),
                    selected: state.prompt.stapleIngredients.contains(staple),
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.green.shade50,
                    onSelected: (_) {
                      context.read<GenerateRecipeBloc>().add(
                          UpdateStapleIngredientsEvent(
                              stapleIngresient: staple));
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildCuisineChips() {
    final cuisines = [
      'Japanese',
      'Chinese',
      'Indian',
      'Greek',
      'Moroccan',
      'Ethiopian',
      'South African'
    ];
    return BlocBuilder<GenerateRecipeBloc, RecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cuisines
              .map((cuisine) => ChoiceChip(
                    label: Text(cuisine),
                    selected: cuisine == state.prompt.cuisine,
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.green.shade50,
                    onSelected: (_) {
                      context
                          .read<GenerateRecipeBloc>()
                          .add(UpdateCuisineEvent(cuisine: cuisine));
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildDietaryRestrictionChips() {
    final restrictions = [
      'vegan',
      'vegetarian',
      'dairy free',
      'kosher',
      'low carb',
      'wheat allergy',
      'nut allergy',
      'fish allergy',
      'soy allergy'
    ];
    return BlocBuilder<GenerateRecipeBloc, RecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: restrictions
              .map((restriction) => FilterChip(
                    label: Text(restriction),
                    selected:
                        state.prompt.dietaryRestrictions.contains(restriction),
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.green.shade50,
                    onSelected: (bool selected) {
                      context.read<GenerateRecipeBloc>().add(
                          UpdateDietaryRestrictionsEvent(
                              dietaryRestrictions: restriction));
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
