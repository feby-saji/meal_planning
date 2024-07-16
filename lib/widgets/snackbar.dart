import 'package:flutter/material.dart';

void kShowSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.redAccent,
    action: SnackBarAction(
      label: 'Retry',
      textColor: Colors.white,
      onPressed: () {
        // Add retry logic here if necessary
      },
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
