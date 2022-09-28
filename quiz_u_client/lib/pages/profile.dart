// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/profile.dart';
import 'package:quiz_u_client/components/BottomNavigation.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/main.dart';

var profileProvider = FutureProvider((ref) async {
  var pref = await ref.watch(sharedPreferencesProvider.future);
  var token = pref.getString('token');
  return await getProfile(token: token!);
});

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(profileProvider).when(data: (data) {
      if (data == null) {
        return PageContainer(
          xPadding: 0.0,
          child: const Center(child: Text('No data')),
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
                  const Text('QuizU',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text('Name: ${data.name}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('Mobile: ${data.mobile}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            // Tab Navigation
            BottomNavigation(),
          ]),
        ),
      );
    }, loading: () {
      return PageContainer(
          child: const Center(child: CircularProgressIndicator()));
    }, error: (e, s) {
      return PageContainer(child: const Center(child: Text('Error')));
    });
  }
}
