import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/family/bloc/family_bloc.dart';

class JoinFamilyDialog extends StatefulWidget {
  const JoinFamilyDialog({super.key});

  @override
  _JoinFamilyDialogState createState() => _JoinFamilyDialogState();
}

class _JoinFamilyDialogState extends State<JoinFamilyDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Family'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: 'Enter family code',
              // You can customize the border, colors, etc., of the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: const EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: const Text('Join'),
          onPressed: () {
            String familyId = _textFieldController.text;
            print('Joining family with code: $familyId');
            Navigator.of(context).pop();
            context.read<FamilyBloc>().add(JoinFamilyEvent(familyId: familyId));
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
