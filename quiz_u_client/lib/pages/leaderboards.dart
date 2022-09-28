import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/leaderboard.dart';
import 'package:quiz_u_client/components/BottomNavigation.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/main.dart';

var leaderboardProvider = FutureProvider((ref) async {
  var pref = await ref.watch(sharedPreferencesProvider.future);
  var token = pref.getString('token');
  return await getLeaderboard(token: token!);
});

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(leaderboardProvider).when(data: (data) {
      if (data == null) {
        return const PageContainer(
          xPadding: 0.0,
          child: Center(child: Text('No data')),
        );
      }
      return PageContainer(
        xPadding: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Leaderboard',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.scores.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data.scores[index].name),
                        trailing: Text(data.scores[index].score.toString()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Tab Navigation
            const BottomNavigation(),
          ]),
        ),
      );
    }, loading: () {
      return PageContainer(
          child: const Center(child: CircularProgressIndicator()));
    }, error: (e, s) {
      return PageContainer(
        child: const Center(
            child: Text('Error getting leaderboard. Try again later.')),
      );
    });
  }
}
