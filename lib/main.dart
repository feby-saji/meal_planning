import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:meal_planning/blocs/bloc/user_type_bloc.dart';
import 'package:meal_planning/db_functions/db_version_manager.dart';
import 'package:meal_planning/firebase_options.dart';
import 'package:meal_planning/db_functions/hive_func.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/models/hive_models/meal_plan_model.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/models/hive_models/user_model.dart';
import 'package:meal_planning/repository/auth_repo.dart';
import 'package:meal_planning/repository/recipe_repo.dart';
import 'package:meal_planning/screens/auth/auth.dart';
import 'package:meal_planning/screens/auth/bloc/auth_bloc.dart';
import 'package:meal_planning/screens/family/bloc/family_bloc.dart';
import 'package:meal_planning/screens/family/family.dart';
import 'package:meal_planning/screens/generate_recipe.dart/bloc/generate_recipe_bloc.dart';
import 'package:meal_planning/screens/meal_plan.dart/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:meal_planning/screens/meal_plan.dart/bloc/meal_search/meal_search_bloc.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meal_planning/screens/splash/splash.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

UserType userType = UserType.free;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive
    ..initFlutter()
    ..registerAdapter(UserModelAdapter())
    ..registerAdapter(RecipeModelAdapter())
    ..registerAdapter(ShopingListItemAdapter())
    ..registerAdapter(MealPlanModelAdapter())
    ..registerAdapter(FamilyAdapter());
  // disabled revenue cat
  // await revenuwCatConfig();
  await dotenv.load(fileName: "env.env");

  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.containsKey(currentUserUId) &&
      prefs.getString(currentUserUId) != null &&
      prefs.getString(currentUserUId)!.isNotEmpty;
  final String? userUid = isLoggedIn ? prefs.getString(currentUserUId) : null;

  FlutterNativeSplash.remove();
  if (userUid != null) {
    DbVersionManager.instance.init();
    //TODO get user uid for migration
    DbVersionManager.instance.checkAndMigrate(currentUserUId);
  }

  FlutterNativeSplash.remove();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

void handleDeepLink(Uri deepLink) async {
  final queryParams = deepLink.queryParameters;
  if (deepLink.path == '/joinFamily' && queryParams.containsKey('familyId')) {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(currentUserUId) &&
        prefs.getString(currentUserUId) != null &&
        prefs.getString(currentUserUId)!.isNotEmpty) {
      final familyId = queryParams['familyId'];
      navigatorKey.currentState?.pushReplacementNamed('/joinFamily', arguments: familyId);
    } else {
      navigatorKey.currentState?.pushNamed('/login');
    }
  }
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
// handle links while app is running
    FirebaseDynamicLinksPlatform.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      handleDeepLink(deepLink);
    }).onError((error) {
      print('Error occurred: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => RecipeRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserTypeBloc(),
          ),
          BlocProvider(
            create: (context) => RecipeBloc(
              recipeRepository: RepositoryProvider.of<RecipeRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => MealPlanSearchBloc(),
          ),
          BlocProvider(
            lazy: true,
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ShoppingListBloc(),
          ),
          BlocProvider(
            create: (context) => MealPlanBloc(),
          ),
          BlocProvider(
            lazy: true,
            create: (context) => FamilyBloc(ShoppingListBloc()),
          ),
          BlocProvider(
            create: (context) => GenerateRecipeBloc(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              dialogTheme: DialogTheme(
            backgroundColor: kClrSecondary,
            titleTextStyle: kMedText,
            contentTextStyle: kSmallText,
          )),
          routes: {
            '/joinFamily': (context) => const FamilyScreen(),
            '/login': (context) => AuthScreen(),
            '/home': (context) => const SplashScreen(),
            // Add more routes as needed for other parts of your app
          },
          home: widget.isLoggedIn ? const SplashScreen() : AuthScreen(),
        ),
      ),
    );
  }
}
