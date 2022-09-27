import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_u_client/main.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => {
        if (value == 0) {Navigator.pushNamed(context, Routes.home)},
        if (value == 1) {Navigator.pushNamed(context, Routes.leaderboard)},
        if (value == 2) {Navigator.pushNamed(context, Routes.profile)},
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
