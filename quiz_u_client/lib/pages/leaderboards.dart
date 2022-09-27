import 'package:flutter/cupertino.dart';
import 'package:quiz_u_client/components/BottomNavigation.dart';
import 'package:quiz_u_client/components/PageContainer.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      xPadding: 0.0,
      child: Column(
        children: [
          const Text('Leaderboard'),
          const Text('Coming Soon'),
          BottomNavigation()
        ],
      ),
    );
  }
}
