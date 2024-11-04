import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/screens/account/functions/gmail.dart';
import 'package:meal_planning/screens/account/functions/url_launcher.dart';
import 'package:meal_planning/screens/account/pages/about%20_us.dart';
import 'package:meal_planning/screens/account/widget/option_tile.dart';
import 'package:meal_planning/screens/family/family.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/main_appbar.dart';
import 'package:meal_planning/widgets/main_container.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = FirebaseAuth.instance.currentUser!.displayName!;
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    // String userName = 'john Doe';
    // String userEmail = 'johnoe@gmail.com';
    final SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: kClrSecondary,
      body: Column(
        children: [
          KAppBarWidget(
            sizeConfig: sizeConfig,
            backBtn: true,
            title: 'Accounts',
            imgPath: null,
          ),
          Expanded(
            child: KMainContainerWidget(
              sizeConfig: sizeConfig,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      userName,
                      style: kLargeText.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(userEmail),
                  ),
                  const SizedBox(height: 50),
                  //
                  // OptionTileWidget(
                  //     iconPath: 'assets/icons/app_icons/premium1.png',
                  //     title: 'Go Premium',
                  //     onTap: () async {
                  //       if (userType == UserType.premium) {
                  //         Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //             builder: (context) => const OnPremiumPlanScreen(),
                  //           ),
                  //         );
                  //       } else {
                  //         // await presentPayWall();
                  //         context.read<UserTypeBloc>().add(CheckUserType());
                  //       }
                  //     }),

                  OptionTileWidget(
                    iconPath: 'assets/icons/app_icons/people.png',
                    title: 'family',
                    onTap: () async {
                      // if (userType == UserType.free) {
                      //   // await presentPayWall();
                      //   context.read<UserTypeBloc>().add(CheckUserType());
                      // } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FamilyScreen()),
                      );
                      // }
                    },
                  ),
                  OptionTileWidget(
                    iconPath: 'assets/icons/app_icons/privacy.png',
                    title: 'Privacy Policy',
                    onTap: () async {
                      Uri uri = Uri.parse(
                          'https://mealplanningprivacypolicy.blogspot.com/2024/07/policy-for-meal-planning-privacy-policy.html');
                      await launchInBrowser(uri);
                    },
                  ),
                  OptionTileWidget(
                    iconPath: 'assets/icons/app_icons/about_us.png',
                    title: 'About us',
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen()),
                      );
                    },
                  ),
                  //
                  OptionTileWidget(
                      iconPath: 'assets/icons/app_icons/gmail.png',
                      title: 'Feedback',
                      onTap: () => openGmailWithSubject(context)),

                  OptionTileWidget(
                    iconPath: 'assets/icons/app_icons/log-out.png',
                    title: 'log out',
                    onTap: () async {
                      _showLogoutConfirmationDialog(context);
                    },
                  ),
                  const Spacer(),
                  const Text('version 1.1.0'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await HiveDb.logOutUser(context);
            },
          ),
        ],
      );
    },
  );
}
