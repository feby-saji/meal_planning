import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/screens/family/bloc/family_bloc.dart';
import 'package:meal_planning/screens/family/widgets/appbar.dart';
import 'package:meal_planning/screens/family/widgets/family_member_tile.dart';
import 'package:meal_planning/screens/family/widgets/join_fam.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/error_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({Key? key}) : super(key: key);

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  void initState() {
    super.initState();
    // event to check if the user is in a family
    context.read<FamilyBloc>().add(CheckIfUserInFamilyEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleDeepLink();
    });
  }

  _handleDeepLink() {
    final familyIdFromDeepLink =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (familyIdFromDeepLink != null && familyIdFromDeepLink.isNotEmpty) {
      context
          .read<FamilyBloc>()
          .add(JoinFamilyEvent(familyId: familyIdFromDeepLink));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is ErrorStateFamily) {
            showErrorSnackbar(
                context: context,
                message: state.error,
                onTap: () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                  }
                });
          }
        },
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            if (state is LoadingStateFamily) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserInFamily) {
              return _buildUserInFamily(state.family, context);
            } else if (state is UserNotInFamily) {
              return _buildUserNotInFamily(context);
            }
            // TODO check if ErrorStateFamily necessary here
            return Column(
              children: [
                AppBarContainer(alreadyInFamily: false),
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              ],
            );
          },
        ),
      ),
    );
  }

  SizedBox _buildUserNotInFamily(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarContainer(alreadyInFamily: false),
          const SizedBox(height: 50),
          Text(
            'You are not in a family',
            style: kMedText.copyWith(color: kClrTextDark),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              ctx.read<FamilyBloc>().add(CreateFamilyEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Create Family',
                style: kSmallText.copyWith(color: kClrTextLight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              showDialog(
                context: ctx,
                builder: (ctx) => const JoinFamilyDialog(),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: kClrPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: Text(
                'Join Family',
                style: kSmallText.copyWith(color: kClrTextLight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInFamily(Family family, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBarContainer(alreadyInFamily: true),
        const SizedBox(height: 35),
        GestureDetector(
          onTap: () {
            // invite users to the fanmily
            shareFamilyID(family.familyId, context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(children: [
                    const Icon(
                      Icons.share,
                      size: 25,
                    ),
                    Text(
                      ' ID: ',
                      style:
                          kMedText.copyWith(fontSize: 18, color: kClrTextDark),
                    )
                  ]),
                ),
                Text(
                  family.familyId,
                  style: kMedText.copyWith(fontSize: 20, color: kClrTextDark),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Members:',
            style: kMedText.copyWith(fontSize: 18, color: kClrTextDark),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: family.members.length,
              itemBuilder: (context, index) {
                return MinimalListTile(title: family.members[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

void showExitFamilyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit from family?'),
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
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FamilyBloc>().add(ExitFamilyEvent());
            },
          ),
        ],
      );
    },
  );
}

void shareFamilyID(String familyId, BuildContext context) async {
  final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse(
        "https://mealplanning.page.link/joinFamily?familyId=$familyId"),
    uriPrefix: "https://mealplanning.page.link",
    androidParameters: const AndroidParameters(
        packageName: "com.gloabalsoftlabs.meal_planning"),
  );
  final dynamicLink = await FirebaseDynamicLinksPlatform.instance
      .buildShortLink(dynamicLinkParams);

  Share.share(
      'Join my family on the Meal Planning App: ${dynamicLink.shortUrl.toString()}');
}
