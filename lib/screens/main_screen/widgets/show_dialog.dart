import 'package:flutter/material.dart';

TextEditingController showDialogTxtCtrl1 = TextEditingController();
final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

Future<dynamic> buildShowDialog({
  required BuildContext context,
  required String title,
  String? text,
  required String btnText,
  required Function() onTap,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            height: 300.0,
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(title),
                Form(
                    key: formKey1,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: showDialogTxtCtrl1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid url';
                        }
                        return null;
                      },
                    )),
                Text(text ?? ''),
                const Spacer(),
                ElevatedButton(onPressed: onTap, child: Text(btnText)),
              ],
            ),
          ),
        ),
      );
    },
  );
}
