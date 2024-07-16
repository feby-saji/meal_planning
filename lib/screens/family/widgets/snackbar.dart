import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blueGrey[900], // Custom background color
      content: const Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
          ),
          SizedBox(width: 12.0),
          Flexible(
            child: Text(
              'Family ID copied',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3), // Snackbar display duration
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}