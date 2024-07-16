import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// color
Color kClrBck = const Color(0xffFFFFFF);
Color kClrPrimary = const Color(0xffFBFADA);
Color kClrSecondary = const Color(0xff436850);
Color kClrAccent = const Color(0xff60C668);
Color kClrTextLight = const Color(0xffFFFFFF);
Color kClrTextGrey = const Color(0xff616161);
Color kClrTextDark = const Color(0xff000000);

// text styles
TextStyle kSmallText = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
);
TextStyle kMedText = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 22,
  // fontWeight: FontWeight.bold,
  fontWeight: FontWeight.w500,
);
TextStyle kLargeText = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

// size cofig
class SizeConfig {
  late final double screenWidth;
  late final double screenHeight;
  late final double blockSizeHor;
  late final double blockSizeVer;

  void init(context) {
    final mediaQuery = MediaQuery.of(context).size;
    screenWidth = mediaQuery.width;
    screenHeight = mediaQuery.height;
    blockSizeHor = screenWidth / 100;
    blockSizeVer = screenHeight / 100;
  }
}
