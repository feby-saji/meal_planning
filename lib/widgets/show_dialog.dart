import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/screens/family/widgets/snackbar.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/screens/recipe/recipe.dart';

void showSaveDialog(BuildContext context, RecipeModel recipe) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context, recipe),
      );
    },
  );
}

Widget dialogContent(BuildContext context, RecipeModel recipe) {
  return Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.only(
          top: 66.0,
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        margin: const EdgeInsets.only(top: 50.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            const Text(
              "save Recipe",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "The recipe will be available offline",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<RecipeBloc>().add(
                        SaveGeneratedRecipe(recipe: recipe, context: context));
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
      const Positioned(
        top: 0.0,
        left: 16.0,
        right: 16.0,
        child: CircleAvatar(
          backgroundColor: Colors.lightGreen,
          radius: 50.0,
          child: Icon(
            Icons.save,
            size: 50.0,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
