import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/screens/main_screen/main_screen.dart';
import 'package:meal_planning/screens/recipe/widgets/tab1.dart';
import 'package:meal_planning/screens/recipe/widgets/tab3.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/show_dialog.dart';

class DetailedRecipeScreen extends StatelessWidget {
  final RecipeModel recipe;
  final bool showSaveIcon;
  final bool goToRecipeScrn;

  const DetailedRecipeScreen({
    super.key,
    required this.recipe,
    this.showSaveIcon = false,
    this.goToRecipeScrn = false,
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: const Color.fromARGB(255, 178, 254, 180),
                pinned: true,
                expandedHeight: 300,
                leading: _buildGobackBtn(context),
                title: Hero(
                  tag: 'Recipe_Hero',
                  child: Text(
                    recipe.title,
                    style: kMedText.copyWith(fontSize: 18),
                  ),
                ),
                actions: [_buildSaveIcon(context)],
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: recipe.img.isNotEmpty
                        ? Image.file(
                            File(recipe.img),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/chef_rat.png',
                          ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    color: Colors.black54,
                    child: const TabBar(
                      tabs: [
                        Tab(text: 'Details'),
                        Tab(text: 'Ingredients'),
                        Tab(text: 'Instructions'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                    ),
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 30),
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
          ),
        ),
      ),
    );
  }

  GestureDetector _buildGobackBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (goToRecipeScrn) {
          navBarInd.value = 2;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: const Icon(
        Icons.chevron_left,
        weight: 0.8,
        size: 36,
      ),
    );
  }

  Padding _buildSaveIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () async {
          showSaveDialog(context, recipe);
        },
        child: Visibility(
          visible: showSaveIcon,
          child: const Icon(
            Icons.save,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

Widget buildTab2(BuildContext context, RecipeModel recipe) {
  return ListView.builder(
    padding: const EdgeInsets.all(0),
    itemCount: recipe.ingredients?.length ?? 0,
    itemBuilder: (context, index) {
      String ing = recipe.ingredients?[index] ?? '_';
      return ListTile(
        leading: roundedContainer(kClrAccent),
        title: Text(ing),
      );
    },
  );
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
