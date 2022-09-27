import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/components/BottomNavigation.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/main.dart';

/// This page has Hero section that says "Ready to start the Quiz?", a button to start the quiz, and tab navigation in the bottom.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get shared preferences
    var perf = ref.watch(sharedPreferencesProvider).value;
    return PageContainer(
      xPadding: 0.0,
      child: Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('QuizU'),
              const SizedBox(height: 20),
              const Text('Ready to start the Quiz?'),
              Text("Your token is ${perf!.getString("token")}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Your token is ${perf!.getString("token")}");
                  Navigator.pushNamed(context, '/quiz');
                },
                child: const Text('Start Quiz'),
              ),
            ],
          ),
        ),
        // Tab Navigation
        BottomNavigation(),
      ]),
    );
  }
}
