import 'package:flutter/material.dart';

class MDrawerWidget extends StatefulWidget {
  const MDrawerWidget({super.key});

  @override
  State<MDrawerWidget> createState() => MDrawerWidgetState();
}

class MDrawerWidgetState extends State<MDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: Text(
          //     _name.isEmpty ? 'User Info' : _name,
          //     style: TextStyle(
          //       color: const Color.fromARGB(255, 132, 107, 107),
          //       fontSize: 24,
          //     ),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          // ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
