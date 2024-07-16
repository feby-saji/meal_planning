import 'package:flutter/material.dart';

class MinimalListTile extends StatelessWidget {
  final String title;

  const MinimalListTile({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 10.0), // Padding around the title text
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 16, // Font size
            fontWeight: FontWeight.normal, // Font weight
          ),
        ),
        onTap: () {
          // Handle tap on the ListTile if needed
          print('Tapped on $title');
        },
      ),
    );
  }
}
