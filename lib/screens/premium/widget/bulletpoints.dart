import 'package:flutter/material.dart';
import 'package:meal_planning/utils/styles.dart';

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ', // Round black bullet with a space for better alignment
          style: kMedText,
        ),
        Text(text,
            style: const TextStyle(
                fontSize: 16, color: Colors.black)), // Black text
      ],
    );
  }
}
