import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/screens/recipe/widgets/tab1.dart';
import 'package:meal_planning/screens/recipe/widgets/tab3.dart';
import 'package:meal_planning/utils/styles.dart';

class DetailedRecipeScreen extends StatelessWidget {
  RecipeModel recipe;
  DetailedRecipeScreen({
    required this.recipe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = [
      Tab(text: 'Details'),
      Tab(text: 'Ingredients'),
      Tab(text: 'Instructions'),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 45, left: 10, right: 10),
          child: Column(
            children: [
              _buildRow(context, recipe.title),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  File(recipe.img),
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const TabBar(tabs: tabs),
              const SizedBox(height: 20),
              buildTabBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildTabBar(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          buildTab1(
            cook: recipe.cook ?? '_',
            prep: recipe.prep ?? '_',
            total: recipe.toal ?? '_',
            recipe: recipe,
          ),
          buildTab2(context, recipe),
          buildTab3(context, recipe),
        ],
      ),
    );
  }

  Row _buildRow(BuildContext context, String recipeName) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.chevron_left,
            weight: 0.8,
            size: 36,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Hero(
            tag: 'Recipe_Hero',
            child: Text(
              recipeName,
              style: kMedText.copyWith(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildTab2(BuildContext context, RecipeModel recipe) {
  return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: recipe.ingredients?.length ?? 0,
      itemBuilder: (context, ind) {
        String ing = recipe.ingredients?[ind] ?? '_';
        return ListTile(
          leading: roundedContainer(kClrAccent),
          title: Text(ing),
        );
      });
}

Container roundedContainer(Color clr) {
  return Container(
    margin: EdgeInsets.zero,
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: clr,
      borderRadius: BorderRadius.circular(50.0),
    ),
  );
}
