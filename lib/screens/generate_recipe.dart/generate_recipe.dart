import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/generate_recipe.dart/bloc/generate_recipe_bloc.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/functions.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/widgets/error_snackbar.dart';

const Color kClrSecondary1 = Color.fromARGB(255, 69, 137, 84);
const Color kClrSecondaryLighter = Color(0xff8a9b7c);

class CreateRecipeScreen extends StatelessWidget {
  const CreateRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kClrSecondary1,
        title: const Text('Create a recipe using AI'),
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/chef_rat.png'),
          ),
        ),
      ),
      body: BlocListener<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeFetchingFailedState) {
            showErrorSnackbar(context: context, message: state.err);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Image of the ingredients you have:'),
              const SizedBox(height: 8),
              _buildImageAddingSection(context),
              const SizedBox(height: 16),
              const Text('Ingredients you have:'),
              const SizedBox(height: 8),
              _buildStapleIngredients(),
              const SizedBox(height: 16),
              const Text("Cuisine:"),
              const SizedBox(height: 8),
              _buildCuisineChips(),
              const SizedBox(height: 16),
              const Text('If any dietary restrictions:'),
              const SizedBox(height: 8),
              _buildDietaryRestrictionChips(),
              const SizedBox(height: 16),
              const Text('Add any details (Optional)'),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'I am planning to have breakfast...',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: kClrSecondaryLighter),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: kClrSecondary1, width: 2),
                  ),
                  filled: true,
                  fillColor: kClrSecondary1.withOpacity(0.1), // Lightest shade
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KButtonRecipeGenerateScreen(
                    icon: Icons.refresh,
                    text: 'Reset Fields',
                    onPressed: () => context
                        .read<GenerateRecipeBloc>()
                        .add(ResetPromptEvent()),
                  ),
                  KButtonRecipeGenerateScreen(
                    icon: Icons.send,
                    text: 'Create Recipe',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const Dialog(
                                backgroundColor: Colors.transparent,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.teal,
                                )),
                              ));
                      context
                          .read<GenerateRecipeBloc>()
                          .add(SubmitPromptEvent(context: context));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildImageAddingSection(BuildContext context) {
    return BlocBuilder<GenerateRecipeBloc, GenerateRecipeState>(
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
        color: kClrSecondary1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kClrSecondary1),
      ),
      child: altImg
          ? const Icon(Icons.add_photo_alternate,
              size: 40, color: kClrSecondary1)
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
    return BlocBuilder<GenerateRecipeBloc, GenerateRecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: staples
              .map((staple) => ChoiceChip(
                    label: Text(staple),
                    selected: state.prompt.stapleIngredients.contains(staple),
                    selectedColor: kClrSecondary1,
                    backgroundColor: kClrSecondary1.withOpacity(0.1),
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
    return BlocBuilder<GenerateRecipeBloc, GenerateRecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cuisines
              .map((cuisine) => ChoiceChip(
                    label: Text(cuisine),
                    selected: cuisine == state.prompt.cuisine,
                    selectedColor: kClrSecondary1,
                    backgroundColor: kClrSecondary1.withOpacity(0.1),
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
    return BlocBuilder<GenerateRecipeBloc, GenerateRecipeState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: restrictions
              .map((restriction) => FilterChip(
                    label: Text(restriction),
                    selected:
                        state.prompt.dietaryRestrictions.contains(restriction),
                    selectedColor: kClrSecondary1,
                    backgroundColor: kClrSecondary1.withOpacity(0.1),
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

class KButtonRecipeGenerateScreen extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onPressed;

  const KButtonRecipeGenerateScreen({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: kClrSecondary1, // Text color
      ),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
