import 'package:flutter/material.dart';
import 'package:meal_planning/utils/styles.dart';

void showDeleteConfirmation({
  required BuildContext context,
  required String contetText,
  required Function() onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(contetText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: kSmallText.copyWith(color: kClrBck),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'Delete',
              style: kSmallText.copyWith(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
