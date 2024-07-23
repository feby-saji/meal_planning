import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/consants/showcaseview_keys.dart';
import 'package:meal_planning/functions/checkUserType.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/main.dart';
import 'package:meal_planning/models/hive_models/meal_plan_model.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/screens/meal_plan.dart/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:meal_planning/screens/meal_plan.dart/bloc/meal_search/meal_search_bloc.dart';
import 'package:meal_planning/screens/meal_plan.dart/functions/dateFormat.dart';
import 'package:meal_planning/screens/meal_plan.dart/functions/show_del_dialog.dart';
import 'package:meal_planning/screens/meal_plan.dart/widgets/meal_tile.dart';
import 'package:meal_planning/screens/recipe/detailed_recipe.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/main_appbar.dart';
import 'package:meal_planning/widgets/main_container.dart';
// import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:showcaseview/showcaseview.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    context.read<MealPlanBloc>().add(GetAllMealToPlanEvent());

    return Column(
      children: [
        KAppBarWidget(
          sizeConfig: sizeConfig,
          title: 'Meal plan',
          imgPath: 'assets/icons/app_icons/settings.png',
        ),
        Expanded(
          child: KMainContainerWidget(
            sizeConfig: sizeConfig,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 7,
              itemBuilder: (BuildContext context, int ind) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        formattedDate(DateTime.now().add(Duration(days: ind))),
                        style: kSmallText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _buildShowDialog(
                          context,
                          DateTime.now().add(Duration(days: ind)),
                        );
                      },
                      child: SingleChildScrollView(
                          child: _buildMealContainer(ind)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Container _buildMealContainer(int ind) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      // height: sizeConfig.screenHeight / 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kClrSecondary,
        borderRadius: BorderRadius.circular(20),
      ),

      child: BlocBuilder<MealPlanBloc, MealPlanState>(
        builder: (context, state) {
          if (state is MealPlanLoadSuccess) {
            return _buildOnMealLoadSuccess(state, ind);
          }
          return const Center(child: Text('No meals '));
        },
      ),
    );
  }

  Widget _buildOnMealLoadSuccess(MealPlanLoadSuccess state, int ind) {
    List<MealPlanModel> todayMeals = [];
    todayMeals = state.meals.where((meal) {
      final DateTime currentDate = DateTime.now().add(Duration(days: ind));
      return meal.mealDate.year == currentDate.year &&
          meal.mealDate.month == currentDate.month &&
          meal.mealDate.day == currentDate.day;
    }).toList();

    if (todayMeals.isEmpty) {
      // print('No meals for ${DateTime.now().add(Duration(days: ind))}');
      return const Center(child: Text('No meals'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todayMeals.length,
        itemBuilder: (context, index) {
          //
          return KMealTileWidget(
            imgPath: todayMeals[index].recipe.img,
            title: todayMeals[index].recipe.title,
            onLogPress: () => showDeleteConfirmation(
                context: context,
                contetText:
                    'Are you sure you want to delete "${todayMeals[index].recipe.title}"?',
                onPressed: () => [
                      context.read<MealPlanBloc>().add(
                          DeleteMealPlanEvent(mealPlan: todayMeals[index])),
                      Navigator.pop(context),
                    ]),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DetailedRecipeScreen(recipe: todayMeals[index].recipe))),
          );
        },
      );
    }
  }

  Future<void> _buildShowDialog(BuildContext context, DateTime date) async {
    final TextEditingController searchController = TextEditingController();
    context.read<MealPlanSearchBloc>().add(MealPlanSerchEvent(val: ''));
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300.0,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search for meals',
                    ),
                    onChanged: (val) {
                      context
                          .read<MealPlanSearchBloc>()
                          .add(MealPlanSerchEvent(val: val));
                    },
                  ),
                  BlocBuilder<MealPlanSearchBloc, MealPlanSearchState>(
                    builder: (context, state) {
                      return _buildStateWidgets(state, context, date);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

_buildStateWidgets(
    MealPlanSearchState state, BuildContext context, DateTime date) {
  if (state is MealPlanSearchResultsState) {
    return _buildSearchResults(state, context, date);
  }
  if (state is MealPlanSearchFailureState) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Center(child: Text(state.err, style: kSmallText))
      ],
    );
  }
  return const SizedBox();
}

Expanded _buildSearchResults(
    MealPlanSearchResultsState state, BuildContext context, DateTime date) {
  return Expanded(
    child: ListView.builder(
      itemCount: state.recipes.length,
      itemBuilder: (_, ind) {
        RecipeModel recipe = state.recipes[ind];
        return ind == 0
            ? _buildResultMealTile(recipe, context, date)
            : _buildResultMealTile(recipe, context, date);
      },
    ),
  );
}



ListTile _buildResultMealTile(
    RecipeModel recipe, BuildContext context, DateTime date) {
  return ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: recipe.img.isNotEmpty
          ? Image.file(
              File(recipe.img),
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/images/chef_rat.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
    ),
    //
    title: Text(
      recipe.title,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () {
      Navigator.pop(context);

      MealPlanModel meal = MealPlanModel(
        mealDate: date,
        recipe: recipe,
      );

      context.read<MealPlanBloc>().add(AddMealToPlanEvent(meal: meal));
    },
  );
}
