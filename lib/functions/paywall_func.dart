//  import 'package:flutter/services.dart';
// import 'package:meal_planning/functions/checkUserType.dart';
// import 'package:meal_planning/main.dart';
// import 'package:purchases_flutter/models/offerings_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

// presentPayWall() async {
//     Offerings? offerings;
//     try {
//       offerings = await Purchases.getOfferings();
//     } on PlatformException catch (e) {
//       print('error $e');
//     }
//     await RevenueCatUI.presentPaywallIfNeeded("premium");
//     await getUserType().then((usertyp) {
//       if (usertyp != null) {
//         userType = usertyp;
//       }
//     });
//   }