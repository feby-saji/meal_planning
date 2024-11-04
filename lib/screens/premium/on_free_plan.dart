import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meal_planning/blocs/user_type_bloc/bloc/user_type_bloc.dart';
import 'package:meal_planning/functions/checkUserType.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/main.dart';
import 'package:meal_planning/screens/connection%20failed/no_internet.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class OnFreePLanScreen extends StatelessWidget {
  const OnFreePLanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle largeTxt = GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontSize: 30,
      letterSpacing: 1,
      height: 1.5,
      fontWeight: FontWeight.w700,
    ));
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are not on Premium',
            textAlign: TextAlign.center,
            style: largeTxt,
          ),
          const SizedBox(height: 50),
          TextButton(
            style: flatButtonStyle,
            onPressed: () async {
              // await RevenueCatUI.presentPaywallIfNeeded("premium");
            
              // context.read<UserTypeBloc>().add(CheckUserType());
            },
            child: Text(
              "go to plans".toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
