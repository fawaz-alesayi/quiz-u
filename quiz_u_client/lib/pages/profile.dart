// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/profile.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/main.dart';
import 'package:quiz_u_client/models/quizAttempt.dart';

var quizAttemptProvider = FutureProvider((ref) async {
  debugPrint("Triggered quizAttemptProvider");
  var pref = await ref.watch(sharedPreferencesProvider.future);
  var attemptsRaw = pref.getStringList('quiz_attempts');
  return attemptsRaw?.map((e) => QuizAttempt.fromJson(e)).toList();
});

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
        return const Center(child: Text('No data'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                var pref = await ref.watch(sharedPreferencesProvider.future);
                await pref.clear();
                // navigate to login
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              icon: const Icon(Icons.logout),
            ),
          ),
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
                SizedBox(height: 60),
                Text('Previous attempts',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                PreviousAttempts(),
              ],
            ),
          ),
        ]),
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, error: (e, s) {
      return const Center(child: Text('Error'));
    });
  }
}

class PreviousAttempts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(quizAttemptProvider).when(data: (data) {
      if (data == null) {
        return const Center(child: Text('No previous attempts'));
      }
      return data.isEmpty
          ? const Center(child: Text('No previous attempts'))
          : SingleChildScrollView(
              child: Column(
                children: data
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // first Text contains date and time in this format: XX:XX AM/PM on DD/MM/YYYY
                              // second Text contains score
                              Text(
                                  '${e.date.hour}:${e.date.minute} ${e.date.hour > 12 ? 'PM' : 'AM'} on ${e.date.day}/${e.date.month}/${e.date.year}',
                                  style: const TextStyle(fontSize: 20)),
                              Text('${e.score} / ${e.quiz.questions.length}',
                                  style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            );
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, error: (e, s) {
      return const Center(child: Text('Could not load previous attempts'));
    });
  }
}
