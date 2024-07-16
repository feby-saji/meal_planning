import 'package:flutter/material.dart';

showDialogueFunc(BuildContext context, Widget widget) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return DefaultTextStyle(style: const TextStyle(), child: widget);
    },
  );
}
