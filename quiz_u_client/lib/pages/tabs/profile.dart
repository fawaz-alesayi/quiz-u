// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/profile.dart';
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
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(profileProvider).when(data: (data) {
      if (data == null) {
        return const Center(child: Text('No data'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                await logout(ref, context);
              },
              icon: const Icon(Icons.logout),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
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
                  const SizedBox(height: 60),
                  const Text('Previous attempts',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  PreviousAttempts(),
                ],
              ),
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

  Future<void> logout(WidgetRef ref, BuildContext context) async {
    var pref = await ref.watch(sharedPreferencesProvider.future);
    await pref.clear();
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}

class PreviousAttempts extends ConsumerWidget {
  const PreviousAttempts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(quizAttemptProvider).when(data: (data) {
      if (data == null) {
        return const Center(child: Text('No previous attempts'));
      }
      return data.isEmpty
          ? const Center(child: Text('No previous attempts'))
          : Column(
              children: data
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // first Text contains date and time in this format: XX:XX AM/PM on DD/MM/YYYY
                            // second Text contains score
                            Text(formatDate(e.date),
                                style: const TextStyle(fontSize: 20)),
                            Text('${e.score} / ${e.quiz.questions.length}',
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ))
                  .toList(),
            );
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, error: (e, s) {
      return const Center(child: Text('Could not load previous attempts'));
    });
  }
}

/// Takes a 24-hour DateTime object and returns a string in the format: "XX:XX AM/PM on DD/MM/YYYY"
///
/// This converts the date from the 24-hour format into the 12-hour format.
String formatDate(DateTime date) {
  var hour = date.hour;
  var minute = date.minute;
  var day = date.day;
  var month = date.month;
  var year = date.year;
  var ampm = hour > 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : hour;
  // Add padding to hour and minute if they are single digit
  var hourPadded = hour.toString().padLeft(2, '0');
  var minutePadded = minute.toString().padLeft(2, '0');
  return '$hourPadded:$minutePadded $ampm on $day/$month/$year';
}
