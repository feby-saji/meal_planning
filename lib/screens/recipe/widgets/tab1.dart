import 'package:flutter/widgets.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/screens/recipe/widgets/details_tile.dart';
import 'package:meal_planning/utils/styles.dart';

Column buildTab1(
    {required String cook,
    required String prep,
    required String total,
    required RecipeModel recipe}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(child: buildTime(total, prep, cook)),
      const SizedBox(height: 40),
      buildKcal(
        carb: recipe.carb ?? '_',
        protein: recipe.protein ?? '_',
        fat: recipe.fat ?? '_',
        kcal: recipe.fat ?? '_',
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Servings :',
            style: kSmallText.copyWith(),
          ),
          Text(
            recipe.servings ?? '_',
            style: kMedText.copyWith(fontSize: 20),
          ),
          const SizedBox(width: 20)
        ],
      )
    ],
  );
}

Row buildKcal({
  required String carb,
  required String protein,
  required String fat,
  required String kcal,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      KDetailTileWidget(
        img: 'assets/icons/app_icons/carb.png',
        title: 'carb',
        value: carb,
      ),
      KDetailTileWidget(
        img: 'assets/icons/app_icons/kcal.png',
        title: 'calorie',
        value: kcal,
      ),
      KDetailTileWidget(
        img: 'assets/icons/app_icons/protein.png',
        title: 'protein',
        value: protein,
      ),
      KDetailTileWidget(
        img: 'assets/icons/app_icons/fat.png',
        title: 'fat',
        value: fat,
      ),
    ],
  );
}

Row buildTime(String total, String prep, String cook) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: 'Total: ', style: kSmallText.copyWith(fontSize: 17)),
        TextSpan(
          text: total,
          style: kMedText.copyWith(fontSize: 18),
        ),
      ])),
      Text.rich(TextSpan(children: [
        TextSpan(text: 'Prep: ', style: kSmallText.copyWith(fontSize: 17)),
        TextSpan(
          text: prep,
          style: kMedText.copyWith(fontSize: 18),
        ),
      ])),
      Text.rich(TextSpan(children: [
        TextSpan(text: 'Cook: ', style: kSmallText.copyWith(fontSize: 17)),
        TextSpan(
          text: cook,
          style: kMedText.copyWith(fontSize: 18),
        ),
      ]))
    ],
  );
}
