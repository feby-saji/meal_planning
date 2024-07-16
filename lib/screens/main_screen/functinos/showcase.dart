// import 'package:flutter/material.dart';
// import 'package:meal_planning/consants/showcaseview_keys.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';

// //1
// Future<void> startShowCaseViewInMealScreen(BuildContext context) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? showCaseViewMainScrn = prefs.getBool('showCaseViewMainScrn');

//   if (showCaseViewMainScrn == null) {
//     startShowCaseViewForMealScreen(context);
//     await prefs.setBool('showCaseViewMainScrn', true);
//   }
//   startShowCaseViewForMealScreen(context);
// }

// void startShowCaseViewForMealScreen(BuildContext context) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     ShowCaseWidget.of(context).startShowCase(
//         [listOfShowCaseViews[0].key, listOfShowCaseViews[1].key]);
//   });
// }

// onFinishMainScreen() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('showCaseViewMainScrn', true);
//   print('Showcase completed');
// }
