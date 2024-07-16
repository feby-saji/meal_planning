import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/auth/bloc/auth_bloc.dart';
import 'package:meal_planning/screens/auth/widgets/bck_img.dart';
import 'package:meal_planning/screens/auth/widgets/build_content.dart';
import 'package:meal_planning/screens/main_screen/main_screen.dart';
import 'package:meal_planning/utils/styles.dart';

class AuthScreen extends StatelessWidget {
  // static const String route = 'Auth_screen';
  final SizeConfig sizeConfig = SizeConfig();

  AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    const snackBar = SnackBar(
      content: Text('authentication failed'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    );

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Stack(
          children: [
            KBackgorundImageWidget(sizeConfig: sizeConfig),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 65),
              child: buildSocialAuths(sizeConfig, context),
            ),
          ],
        ),
      ),
    );
  }
}
