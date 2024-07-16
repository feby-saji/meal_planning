import 'package:flutter/material.dart';
import 'package:meal_planning/utils/styles.dart';

class OptionTileWidget extends StatelessWidget {
  const OptionTileWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SizedBox(
          child: Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),
        ),
        title: Text(
          title,
          style: kSmallText,
        ),
        trailing: Image.asset(
          'assets/icons/app_icons/r-chevron.png',
          width: 30,
        ),
      ),
    );
  }
}
