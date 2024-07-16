import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/consants/showcaseview_keys.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/models/showcase.dart';
import 'package:meal_planning/repository/firestore.dart';
import 'package:meal_planning/repository/recipe_repo.dart';
import 'package:meal_planning/screens/generate_recipe.dart/generate_recipe.dart';
import 'package:meal_planning/screens/main_screen/functinos/showcase.dart';
import 'package:meal_planning/screens/main_screen/widgets/show_dialog.dart';
import 'package:meal_planning/screens/meal_plan.dart/meal_plan.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/screens/recipe/recipe.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meal_planning/screens/shopping_list/shopping_list.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/Drawer.dart';
import 'package:meal_planning/widgets/bottom_nav_bar.dart';
import 'package:meal_planning/widgets/snackbar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:showcaseview/showcaseview.dart';

ValueNotifier<int> navBarInd = ValueNotifier(1);

class MainScreen extends StatelessWidget {
  // static String route = 'main_screen';
  MainScreen({super.key});

  List screens = [
    const ShoppingListScreen(),
    const MealPlanScreen(),
    const RecipeScreen(),
    const CreateRecipeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return ValueListenableBuilder(
        valueListenable: navBarInd,
        builder: (BuildContext context, int ind, _) {
          return Scaffold(
            backgroundColor: kClrSecondary,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[ind],
            ),
            bottomNavigationBar: const BottomNavBarWidget(),
            floatingActionButton: Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: _buildAddButton(ind, context)),
          );
        });
  }

  Visibility _buildAddButton(int ind, BuildContext context) {
    return Visibility(
      visible: ind == 0 || ind == 2,
      child: FloatingActionButton(
          backgroundColor: kClrSecondary,
          child: Image.asset(
            'assets/icons/app_icons/add.png',
            width: 30,
            height: 30,
          ),
          onPressed: () {
            if (ind == 0) {
              _buildAddShoppingItemDialog(context);
            } else if (ind == 2) {
              showAddRecipeDialog(context, showDialogTxtCtrl1);
            }
          }),
    );
  }

  void showAddRecipeDialog(
      BuildContext context, TextEditingController controller) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200, // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Add Recipe Link',
              style: TextStyle(color: Colors.black)), // Set title text color
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the URL of the recipe:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black), // Set content text color
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe URL';
                    }
                    // You can add additional validation here if needed
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'https://www.example.com/recipe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.red), // Initial border color
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade400,
              ),
              child: const Text('Add Recipe',
                  style:
                      TextStyle(color: Colors.white)), // Set button text color
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String recipeLink = controller.text.trim();
                  Navigator.of(context).pop();
                  context
                      .read<RecipeBloc>()
                      .add(AddNewRecipeEvent(url: recipeLink));
                  controller.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  _buildAddShoppingItemDialog(BuildContext context) {
    TextEditingController itemNameCtrl = TextEditingController();
    TextEditingController qtyCtrl = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              height: 200.0,
              width: 300.0,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: itemNameCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Item name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Item name cannot be empty';
                        }
                        return null; // Return null if validation passes
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Qty',
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          final item = ShopingListItem(
                            name: itemNameCtrl.text.trim(),
                            quantity: qtyCtrl.text.isEmpty ? '1' : qtyCtrl.text,
                          );
                          context.read<ShoppingListBloc>().add(
                                ShoppingListAddEvent(item: item),
                              );
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
