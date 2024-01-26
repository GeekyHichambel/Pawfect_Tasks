import 'package:flutter/cupertino.dart';

BottomNavigationBarItem customNavigationBarItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 0),
      ],
    ),
    label: label,
  );
}