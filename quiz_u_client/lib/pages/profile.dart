import 'package:flutter/material.dart';
import 'package:quiz_u_client/components/BottomNavigation.dart';
import 'package:quiz_u_client/components/PageContainer.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      xPadding: 0.0,
      child: Column(
        children: [
          const Text('Profile'),
          const Text('Coming Soon'),
          Expanded(child: SizedBox()),
          BottomNavigation()
        ],
      ),
    );
  }
}
