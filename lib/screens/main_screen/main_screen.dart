import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/screens/generate_recipe.dart/generate_recipe.dart';
import 'package:meal_planning/screens/main_screen/widgets/show_dialog.dart';
import 'package:meal_planning/screens/meal_plan.dart/meal_plan.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/screens/recipe/recipe.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meal_planning/screens/shopping_list/shopping_list.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/bottom_nav_bar.dart';

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
                margin: const EdgeInsets.only(right: 16.0), child: _buildAddButton(ind, context)),
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

  void showAddRecipeDialog(BuildContext context, TextEditingController controller) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Add Recipe Link', style: TextStyle(color: Colors.black)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the URL of the recipe:',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe URL';
                    }
                    // can add additional validation here if needed
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'https://www.example.com/recipe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red), // Initial border color
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
                controller.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade400,
              ),
              child: const Text('Add Recipe',
                  style: TextStyle(color: Colors.white)), // Set button text color
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String recipeLink = controller.text.trim();
                  Navigator.of(context).pop();
                  context.read<RecipeBloc>().add(AddNewRecipeEvent(url: recipeLink));
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
          backgroundColor: Colors.white, // Dialog background
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adapts to content size
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Add Shopping Item',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black87, // Title color
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: itemNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Item name',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100, // Light background for input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Item name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Quantity',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text('Add'),
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
