import 'package:flutter/widgets.dart';
import 'package:meal_planning/utils/styles.dart';

class KLogInBtnWidget extends StatelessWidget {
  KLogInBtnWidget({
    super.key,
    required this.sizeConfig,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final SizeConfig sizeConfig;
  final String icon;
  final String title;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sizeConfig.screenWidth / 1.1,
        height: sizeConfig.screenHeight / 13,
        decoration: BoxDecoration(
          color: kClrAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: sizeConfig.blockSizeHor * 5),
            Image.asset(
              icon,
              width: 40,
              height: 40,
            ),
            SizedBox(width: sizeConfig.blockSizeHor * 5),
            Text(
              title,
              style: kMedText,
            )
          ],
        ),
      ),
    );
  }
}
