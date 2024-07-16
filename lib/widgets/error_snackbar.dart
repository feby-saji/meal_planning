import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    duration:const Duration(seconds: 5),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    action: SnackBarAction(
      label: 'DISMISS',
      textColor: Colors.white,
      onPressed: () {
        // Do something when the user dismisses the snackbar
      },
    ),
  );
ScaffoldMessenger.of(context).showSnackBar(snackBar);

}
