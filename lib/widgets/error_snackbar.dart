import 'package:flutter/material.dart';

void showErrorSnackbar(
    {required BuildContext context,
    required String message,
    Function()? onTap}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    action: SnackBarAction(
      label: 'DISMISS',
      textColor: Colors.white,
      onPressed: onTap ?? () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
