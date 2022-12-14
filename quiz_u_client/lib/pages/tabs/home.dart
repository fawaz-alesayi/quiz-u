import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/quiz.dart';
import 'package:quiz_u_client/main.dart';
import 'package:quiz_u_client/models/quiz.dart';

final quizProvider = FutureProvider<Quiz?>((ref) async {
  final pref = await ref.watch(sharedPreferencesProvider.future);
  final quiz = await getQuiz(token: pref.getString('token')!);
  return quiz;
});

/// This page has Hero section that says "Ready to start the Quiz?", a button to start the quiz, and tab navigation in the bottom.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var perf = ref.watch(sharedPreferencesProvider).value;
    ref.watch(quizProvider).value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('QuizU',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              Text(
                'Ready to start the Quiz, ${perf?.getString('name')}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Text("Your token is ${perf.getString("token")}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Your token is ${perf?.getString("token")}");
                  Navigator.pushNamed(context, Routes.quiz);
                },
                child: const Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
