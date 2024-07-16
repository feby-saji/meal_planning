import 'package:flutter/material.dart';
import 'package:meal_planning/screens/premium/widget/bulletpoints.dart';
import 'package:meal_planning/utils/styles.dart';

class OnPremiumPlanScreen extends StatelessWidget {
  const OnPremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig for responsive design
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kClrPrimary, // Set the primary color for the app bar
        title:  Text('Premium Plan', style: TextStyle(color: kClrTextDark)),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: kClrTextDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: kClrBck, // Set the background color using your kClrBck constant
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'You are already on Premium!',
                  style: kMedText.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: kClrTextDark),
                ),
              ),
              const SizedBox(height: 20),
              const BulletPoint(text: 'Create/join family to share recipes.'),
              const BulletPoint(text: 'Import recipes from various sources.'),
              const BulletPoint(text: 'Plan your meals efficiently.'),
              const BulletPoint(text: 'Sync your shopping list across devices.'),
              const SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Enjoy these exclusive Premium features!',
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: kClrTextGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
