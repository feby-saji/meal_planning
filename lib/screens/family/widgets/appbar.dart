import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meal_planning/screens/family/family.dart';
import 'package:meal_planning/screens/main_screen/main_screen.dart';
import 'package:meal_planning/utils/styles.dart';

class AppBarContainer extends StatelessWidget {
  AppBarContainer(
      {super.key, required this.alreadyInFamily});

  bool alreadyInFamily = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      color: kClrPrimary,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                }
              },
              icon: const Icon(Icons.arrow_back)),
          Text(
            'Family',
            style: kMedText,
          ),
          const Spacer(),
          Visibility(
            visible: alreadyInFamily,
            child: IconButton(
                onPressed: () => showExitFamilyDialog(context),
                icon: const Icon(Icons.exit_to_app_outlined)),
          )
        ],
      ),
    );
  }
}
