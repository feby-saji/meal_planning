import 'package:flutter/material.dart';
import 'package:meal_planning/screens/main_screen/main_screen.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: navBarInd,
        builder: (BuildContext context, int val, _) {
          return BottomNavigationBar(
            currentIndex: navBarInd.value,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.green,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
            ],
            onTap: (ind) {
              navBarInd.value = ind;
              // controllerAni.forward(from: 0);
              navBarInd.notifyListeners();
            },
          );
        });
  }
}
