import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/auth/bloc/auth_bloc.dart';
import 'package:meal_planning/screens/auth/widgets/btn.dart';
import 'package:meal_planning/utils/styles.dart';

Widget buildSocialAuths(SizeConfig sizeConfig, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Center(
        child: Text(
          'Start planning your meals now',
          textAlign: TextAlign.center,
          style: kLargeText.copyWith(color: kClrTextLight, fontSize: 28),
        ),
      ),
      Column(
        children: [
          KLogInBtnWidget(
            sizeConfig: sizeConfig,
            icon: 'assets/icons/google.png',
            title: 'Sign in with Google',
            onTap: () => context.read<AuthBloc>().add(GoogleAuthEvent()),
          ),
          SizedBox(height: sizeConfig.blockSizeVer * 2),
          //
          // KLogInBtnWidget(
          //   sizeConfig: sizeConfig,
          //   icon: 'assets/icons/x.png',
          //   title: 'Sign in with x',
          //   onTap: () => context.read<AuthBloc>().add(XAuthEvent()),
          // ),
          // SizedBox(height: sizeConfig.blockSizeVer * 2),
          // //
          // KLogInBtnWidget(
          //   sizeConfig: sizeConfig,
          //   icon: 'assets/icons/facebook.png',
          //   title: 'Sign in with fb',
          //   onTap: () => context.read<AuthBloc>().add(FacebookAuthEvent()),
          // ),
        ],
      ),
    ],
  );
}
