import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meal_planning/db_functions/hive_func.dart';
import 'package:meal_planning/main.dart';
import 'package:meal_planning/utils/styles.dart';

class KMainContainerWidget extends StatelessWidget {
  KMainContainerWidget({
    super.key,
    required this.child,
    required this.sizeConfig,
  });

  Widget child;
  SizeConfig sizeConfig;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      decoration: BoxDecoration(
          color: kClrBck,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      width: sizeConfig.screenWidth,
      child: child,
    );
  }
}
