import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meal_planning/consants/showcaseview_keys.dart';
import 'package:meal_planning/functions/checkUserType.dart';
import 'package:meal_planning/functions/network_connection.dart';
import 'package:meal_planning/main.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/models/hive_models/meal_plan_model.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/models/hive_models/user_model.dart';
import 'package:meal_planning/repository/firestore.dart';
import 'package:meal_planning/screens/auth/auth.dart';
import 'package:meal_planning/screens/connection%20failed/no_internet.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/prompt_function.dart';
import 'package:meal_planning/screens/main_screen/functinos/showcase.dart';
import 'package:meal_planning/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

// sharedPrefs
String currentUserUId = 'CURRENT_USER_UID';
String showCaseView = 'SHOWCASEVIEW';
late Box<UserModel> userBox;
late String userUid;
FireStoreFunctions fireStore = FireStoreFunctions();

enum UserType {
  free,
  premium,
}

class HiveDb {
  static createUser(User user) async {
    userType = UserType.free;
    userUid = user.uid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userBox = await Hive.openBox<UserModel>(user.uid);

    prefs.setString(currentUserUId, user.uid);

    UserModel userModel = UserModel(
      uid: user.uid,
      isLoggedIn: true,
      name: user.displayName!,
      recipes: [],
      favRecipes: [],
      shoppingListItems: [],
      plannedMeals: [],
      // not using isPremiumUser
      isPremiumUser: false,
    );
    await userBox.put(user.uid, userModel);

    await fireStore.createUser(user);
  }

  Future<void> getLoggedInUser(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      final prefs = await SharedPreferences.getInstance();
      // Check if user exists
      if (prefs.containsKey(currentUserUId) &&
          prefs.getString(currentUserUId) != null &&
          prefs.getString(currentUserUId)!.isNotEmpty) {
        userUid = prefs.getString(currentUserUId)!;
        print('user $userUid logged in');

        userBox = await Hive.openBox<UserModel>(userUid);
        await HiveDb.deleteOutdatedMeals();

        // Get deep link if app started by deep link
        final PendingDynamicLinkData? initialLink =
            await FirebaseDynamicLinksPlatform.instance.getInitialLink();

        if (initialLink != null) {
          handleDeepLink(initialLink.link, context);
        } else {
          navigator.pushReplacement(
            MaterialPageRoute(
              builder: (context) => ShowCaseWidget(
                builder: (context) => MainScreen(),
              ),
            ),
          );
        }
      } else {
        print('//getLoggedInUser userType is $userType');
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    } catch (error) {
      print('//getLoggedInUser Error getting logged-in user: $error');
    }
  }

  void handleDeepLink(Uri deepLink, BuildContext context) {
    final queryParams = deepLink.queryParameters;
    if (deepLink.path == '/joinFamily' && queryParams.containsKey('familyId')) {
      final familyId = queryParams['familyId'];
      Navigator.of(context)
          .pushReplacementNamed('/joinFamily', arguments: familyId);
      print('///Navigating to family screen with familyId: $familyId /// ');
    } else {
      print('///Invalid or unrecognized deep link: $deepLink ///');
      Navigator.of(context)
          .pushReplacementNamed('/home'); // Replace with your home screen route
    }
  }

  signOutUser(String uid, bool loggedIn) async {
    await FirebaseAuth.instance.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(currentUserUId, '');
  }

  static logOutUser(context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await FirebaseAuth.instance.signOut();
      await prefs.setString(currentUserUId, '');

      userBox = await Hive.openBox<UserModel>(userUid);
      UserModel user = userBox.get(userUid)!;
      user.isLoggedIn = false;
      await userBox.put(userUid, user);
      userBox.close();
      userUid = '';

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    } catch (e) {
      print('somthing went worng while log out');
    }
  }

// not nocessary to store user type in hive
  // setUserIsPremium(bool isPremium) async {
  //   userBox = await Hive.openBox<UserModel>(userUid);
  //   UserModel user = userBox.get(userUid)!;
  //   user.isPremiumUser = false;
  //   await userBox.put(userUid, user);
  // }

// family functions
// get from firestore and put in hive
  static Future<void> updateFamily(Family family) async {
    try {
      UserModel user = userBox.get(userUid)!;
      user.family = family;
      await userBox.put(userUid, user);
      print('//updateFamily ${user.family!.members.length}');
    } catch (e) {
      print('Error updating family: $e');
    }
  }

  static Future<Family?> getFamilyHive() async {
    try {
      UserModel user = userBox.get(userUid)!;
      if (user.family != null) {
        return user.family!;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting family: $e');
      return Family(familyId: 'no family id found', creator: '', members: []);
    }
  }

// recipe functions
  static Future<List<RecipeModel>> addNewRecipe(recipe) async {
    userBox = await Hive.openBox<UserModel>(userUid);
    UserModel user = userBox.get(userUid)!;
    user.recipes.add(recipe);
    await userBox.put(userUid, user);
    return user.recipes;
  }

  static Future<bool> checkIfRecipeExists(RecipeModel recipe) async {
    userBox = await Hive.openBox<UserModel>(userUid);
    UserModel user = userBox.get(userUid)!;
    bool recExist = user.recipes.any((rec) => rec.title == recipe.title);

    if (recExist) {
      return true;
    }
    return false;
  }

  static Future<List<RecipeModel>>? loadAllRecipes() async {
    userBox = await Hive.openBox(userUid);
    UserModel user = userBox.get(userUid)!;
    return user.recipes;
  }

  static Future<List<RecipeModel>> getRecipes(String val) async {
    userBox = await Hive.openBox(userUid);
    UserModel user = userBox.get(userUid)!;
    return user.recipes
        .where((item) => item.title.toLowerCase().contains(val.toLowerCase()))
        .toList();
  }

  static deletRecipe(RecipeModel recipe) async {
    UserModel? user = userBox.get(userUid);
    if (user != null) {
      user.recipes.removeWhere((element) => element == recipe);
      await userBox.put(userUid, user);
    }
  }

  static updateFav(RecipeModel recipe, bool isFav) async {
    UserModel? user = userBox.get(userUid);
    if (user != null) {
      RecipeModel updateRecipe =
          user.recipes.firstWhere((element) => element == recipe);
      updateRecipe.isFav = isFav;
      await userBox.put(userUid, user);
    }
  }

  static Future<List<RecipeModel>> searchRecipes(String val, bool isFav) async {
    userBox = await Hive.openBox(userUid);
    UserModel user = userBox.get(userUid)!;
    if (isFav) {
      return user.recipes
          .where((item) =>
              item.title.toLowerCase().contains(val.toLowerCase()) &&
              item.isFav == isFav)
          .toList();
    } else {
      return user.recipes
          .where((item) => item.title.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
  }

  // shoppingList functions
  static List<ShopingListItem>? loadAllShoppingItem() {
    UserModel? user = userBox.get(userUid);
    if (user != null) {
      return user.shoppingListItems;
    }
    return null;
  }

  static addNewShoppingItem(ShopingListItem item) async {
    UserModel? user = userBox.get(userUid);
    if (user != null) {
      int existingInd = user.shoppingListItems
          .indexWhere((element) => element.name == item.name);

      // check if item exists
      if (existingInd != -1) {
        int newQty = int.parse(user.shoppingListItems[existingInd].quantity) +
            int.parse(item.quantity);
        user.shoppingListItems[existingInd].quantity = newQty.toString();
      } else {
        item.category = ingredientCategories[item.name] ?? 'others';
        user.shoppingListItems.add(item);
      }
      await userBox.put(userUid, user);
    }
  }

  static void removeShoppingListItem(ShopingListItem item) async {
    UserModel? user = userBox.get(userUid);
    int ind = user!.shoppingListItems.indexOf(item);
    user.shoppingListItems.removeAt(ind);
    await userBox.put(userUid, user);
  }

  static void clearShoppingListItems() async {
    UserModel? user = userBox.get(userUid);
    user!.shoppingListItems = [];
    await userBox.put(userUid, user);
  }

  // meal plan functions
  static addMealToPlan(MealPlanModel meal) async {
    UserModel? user = userBox.get(userUid);
    user!.plannedMeals.add(meal);
    await userBox.put(userUid, user);
  }

  static deleteMealplans(MealPlanModel mealPlanToDel) async {
    UserModel? user = userBox.get(userUid);
    user!.plannedMeals.removeWhere((mealPlan) => mealPlan == mealPlanToDel);
    await userBox.put(userUid, user);
  }

  static List<MealPlanModel>? getAllMealPlans() {
    UserModel? user = userBox.get(userUid);
    return user?.plannedMeals;
  }

// delete the outdated meals
  static deleteOutdatedMeals() async {
    UserModel? user = userBox.get(userUid);
    user!.plannedMeals.removeWhere((mealPlan) => mealPlan.mealDate
        .isBefore(DateTime.now().subtract(const Duration(days: 1))));
    await userBox.put(userUid, user);
  }
}

//
const Map<String, String> ingredientCategories = {
  'milk': 'Dairy',
  'chicken': 'Meat',
  'beef': 'Meat',
  'pork': 'Meat',
  'lamb': 'Meat',
  'fish': 'Seafood',
  'shrimp': 'Seafood',
  'salmon': 'Seafood',
  'tuna': 'Seafood',
  'tilapia': 'Seafood',
  'cod': 'Seafood',
  'haddock': 'Seafood',
  'halibut': 'Seafood',
  'trout': 'Seafood',
  'lobster': 'Seafood',
  'crab': 'Seafood',
  'clam': 'Seafood',
  'mussels': 'Seafood',
  'squid': 'Seafood',
  'octopus': 'Seafood',
  'scallop': 'Seafood',
  'egg': 'Protein',
  'tofu': 'Protein',
  'tempeh': 'Protein',
  'beans': 'Protein',
  'lentils': 'Protein',
  'chickpeas': 'Protein',
  'peas': 'Protein',
  'nuts': 'Protein',
  'seeds': 'Protein',
  'quinoa': 'Grain',
  'rice': 'Grain',
  'pasta': 'Grain',
  'bread': 'Grain',
  'oats': 'Grain',
  'barley': 'Grain',
  'couscous': 'Grain',
  'bulgur': 'Grain',
  'corn': 'Grain',
  'potato': 'Starch',
  'sweet potato': 'Starch',
  'yam': 'Starch',
  'pumpkin': 'Starch',
  'carrot': 'Vegetable',
  'broccoli': 'Vegetable',
  'spinach': 'Vegetable',
  'kale': 'Vegetable',
  'lettuce': 'Vegetable',
  'cabbage': 'Vegetable',
  'cauliflower': 'Vegetable',
  'bell pepper': 'Vegetable',
  'tomato': 'Vegetable',
  'cucumber': 'Vegetable',
  'zucchini': 'Vegetable',
  'onion': 'Vegetable',
  'garlic': 'Vegetable',
  'ginger': 'Vegetable',
  'mushroom': 'Vegetable',
  'asparagus': 'Vegetable',
  'celery': 'Vegetable',
  'avocado': 'Fruit',
  'banana': 'Fruit',
  'apple': 'Fruit',
  'orange': 'Fruit',
  'grape': 'Fruit',
  'strawberry': 'Fruit',
  'blueberry': 'Fruit',
  'raspberry': 'Fruit',
  'blackberry': 'Fruit',
  'pineapple': 'Fruit',
  'watermelon': 'Fruit',
  'melon': 'Fruit',
  'kiwi': 'Fruit',
  'mango': 'Fruit',
  'pear': 'Fruit',
  'peach': 'Fruit',
  'plum': 'Fruit',
  'cherry': 'Fruit',
  'lemon': 'Fruit',
  'lime': 'Fruit',
  'grapefruit': 'Fruit',
  'coconut': 'Fruit',
  'dates': 'Fruit',
  'fig': 'Fruit',
  'pomegranate': 'Fruit',
  'raisins': 'Fruit',
  'cranberries': 'Fruit',
  'honey': 'Sweetener',
  'sugar': 'Sweetener',
  'maple syrup': 'Sweetener',
  'agave syrup': 'Sweetener',
  'molasses': 'Sweetener',
  'chocolate': 'Sweetener',
  'vanilla extract': 'Flavoring',
  'cinnamon': 'Flavoring',
  'nutmeg': 'Flavoring',
  'allspice': 'Flavoring',
  'cloves': 'Flavoring',
  'salt': 'Seasoning',
  'black pepper': 'Seasoning',
  'white pepper': 'Seasoning',
  'paprika': 'Seasoning',
  'cayenne pepper': 'Seasoning',
  'chili powder': 'Seasoning',
  'curry powder': 'Seasoning',
  'oregano': 'Seasoning',
  'thyme': 'Seasoning',
  'basil': 'Seasoning',
  'rosemary': 'Seasoning',
  'bay leaf': 'Seasoning',
  'coriander': 'Seasoning',
  'parsley': 'Seasoning',
  'dill': 'Seasoning',
  'turmeric': 'Seasoning',
  'mustard': 'Condiment',
  'ketchup': 'Condiment',
  'mayonnaise': 'Condiment',
  'relish': 'Condiment',
  'soy sauce': 'Condiment',
  'hot sauce': 'Condiment',
  'barbecue sauce': 'Condiment',
  'vinegar': 'Condiment',
  'olive oil': 'Oil',
  'vegetable oil': 'Oil',
  'coconut oil': 'Oil',
  'sesame oil': 'Oil',
  'butter': 'Dairy',
  'cheese': 'Dairy',
  'yogurt': 'Dairy',
  'cream': 'Dairy',
  'margarine': 'Dairy',
};
