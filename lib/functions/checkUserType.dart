// import 'package:meal_planning/consants/revenue_cat.dart';
// import 'package:meal_planning/consants/store_config.dart';
// import 'package:meal_planning/functions/network_connection.dart';
// import 'package:meal_planning/hive_db/db_functions.dart';
// // import 'package:purchases_flutter/purchases_flutter.dart';

// Future<UserType?> getUserType() async {
//   // check network connection
//   if (await connectedToInternet()) {
//     try {
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();

//       if (customerInfo.entitlements.all[entitlementID] != null &&
//           customerInfo.entitlements.all[entitlementID]?.isActive == true) {
//         return UserType.premium;
//       } else {
//         return UserType.free;
//       }
//     } catch (e) {
//       print(e);
//     }
//   } else {
//     return null;
//   }
//   return null;
// }

// revenuwCatConfig() async {
//   // check network connection
//   if (await connectedToInternet()) {
//     StoreConfig(
//       store:  Store.amazon,
//       apiKey: amazonApiKey 
//     );

//     PurchasesConfiguration configuration;
//     configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//       ..appUserID = null
//       ..observerMode = false;
//     await Purchases.setLogLevel(LogLevel.debug);
//     await Purchases.configure(configuration);
//   }
// }
