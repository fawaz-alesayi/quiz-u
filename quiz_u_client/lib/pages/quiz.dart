// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/score.dart';
import 'package:quiz_u_client/components/page_container.dart';
import 'package:quiz_u_client/main.dart';
import 'package:quiz_u_client/models/quiz.dart';
import 'package:quiz_u_client/models/quizAttempt.dart';
import 'package:quiz_u_client/pages/home.dart';
import 'package:quiz_u_client/pages/otp.dart';
import 'package:share_plus/share_plus.dart';

const QuizDuration = Duration(seconds: 5);

class QuizPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(quizProvider).when(
        loading: () => const PageContainer(
            child: Center(child: CircularProgressIndicator())),
        error: (error, stack) => const PageContainer(
            child: Center(child: Text("Sorry can't load the quiz right now"))),
        data: (data) {
          final quesitons = data!.questions;
          return PageContainer(
            child: QuestionsWidget(questions: quesitons),
          );
        });
  }
}

class QuestionsWidget extends ConsumerStatefulWidget {
  final List<Question> questions;

  const QuestionsWidget({Key? key, required this.questions}) : super(key: key);

  @override
  ConsumerState<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends ConsumerState<QuestionsWidget> {
  /// Clock is what drives the re-renders of this widget. it reduces QuizDuration by 1 second every second
  Timer? clock;

  bool timerFinished = false;
  Duration quizDuration = QuizDuration;
  bool failedQuiz = false;
  int questionIndex = 0;
  int score = 0;
  bool skipUsed = false;
  DateTime? startTime;

  /// Answers given
  List<String> answers = [];

  /// quizTimer is only responsible for what happens after the quiz ends
  Timer? quizTimer;

  @override
  void initState() {
    super.initState();
    startTimer(onFinish: () {
      failedQuiz = false;
      timerFinished = true;
    });
    startTime = DateTime.now();
  }

  /// clear timers when this widget gets removed
  @override
  void dispose() {
    super.dispose();
    clock!.cancel();
    quizTimer!.cancel();
  }

  void startTimer({Function? onFinish}) {
    quizTimer = Timer(quizDuration, () {
      debugPrint("Timer finished");
      if (onFinish != null) {
        onFinish();
      }
    });
    clock = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    setState(() {
      final seconds = quizDuration.inSeconds - 1;
      if (seconds < 0) {
        quizTimer!.cancel();
      } else {
        quizDuration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() {
      clock!.cancel();
      quizTimer!.cancel();
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      timerFinished = false;
      quizDuration = QuizDuration;
    });
  }

  void resetQuiz() {
    setState(() {
      failedQuiz = false;
      questionIndex = 0;
      skipUsed = false;
      score = 0;
      answers = [];
    });
    resetTimer();
    startTimer(onFinish: () {
      failedQuiz = false;
      timerFinished = true;
    });
  }

  void failQuiz() {
    setState(() {
      failedQuiz = true;
    });
    stopTimer();
  }

  void postResult() async {
    // get shared prefrences
    var pref = await ref.watch(sharedPreferencesProvider.future);
    var response = await postScore(
        token: pref.getString('token')!, score: score.toString());
    if (response == null) {
      showErrorSnackBar(
          context, "Sorry, we could not add your score to the leaderbords.");
    } else {
      debugPrint(response.toString());
    }
  }

  Future<void> saveResultLocally(QuizAttempt attempt) async {
    var pref = await ref.watch(sharedPreferencesProvider.future);
    List<QuizAttempt> attempts = [];
    for (var attempt in pref.getStringList('quiz_attempts') ?? []) {
      attempts.add(QuizAttempt.fromJson(attempt));
    }
    attempts.add(attempt);
    var result = await pref.setStringList(
        'quiz_attempts', attempts.map((e) => e.toJson()).toList());
    if (!result) {
      debugPrint("Could not save quiz attempt locally");
    } else {
      debugPrint("Saved quiz attempt locally");
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) {
      if (n < 0) {
        return "0".padLeft(2, '0');
      }
      return n.toString().padLeft(2, '0');
    }

    final minutes = strDigits(quizDuration.inMinutes.remainder(60));
    final seconds = strDigits((quizDuration.inSeconds).remainder(60));
    if (!failedQuiz) {
      if (((questionIndex + 1) > widget.questions.length) || timerFinished) {
        stopTimer();
        // postResult();
        saveResultLocally(QuizAttempt(
            choices: answers,
            score: score,
            date: startTime!,
            quiz: Quiz(questions: widget.questions)));
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exit button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.blue,
                  )),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Time left: $minutes:$seconds"),
                    const SizedBox(height: 20),
                    const Text("You finished the quiz!"),
                    const SizedBox(height: 20),
                    Text("Your score was $score/${widget.questions.length}"),
                    // Share button
                    OutlinedButton(
                      onPressed: () {
                        Share.share(
                            "I answered $score correct answers in QuizU!");
                      },
                      child: const Text("Share your score"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Time left: $minutes:$seconds"),
            const SizedBox(height: 20),
            Text(widget.questions[questionIndex].question),
            for (var answer
                in widget.questions[questionIndex].answers.entries) ...{
              TextButton(
                  onPressed: () {
                    if (correct(widget.questions[questionIndex], answer.key)) {
                      debugPrint(
                          "Answered to question $questionIndex correctly");
                      // Move to next question
                      setState(() {
                        score++;
                        questionIndex++;
                        answers.add(answer.key);
                      });
                    } else {
                      debugPrint(
                          "Answered to question $questionIndex incorrectly");
                      setState(() {
                        failedQuiz = true;
                      });
                    }
                  },
                  child: Text("${answer.key}. ${answer.value}")),
            },
            if (!skipUsed) ...{
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      skipUsed = true;
                      questionIndex++;
                    });
                  },
                  child: const Text("Skip"))
            }
          ],
        ),
      );
    } else {
      stopTimer();
      return Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.blue,
                )),
          ),
          // Exit button
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Exit button
                  const Text(
                    "Wrong Answer. You failed the quiz 😔",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        resetQuiz();
                      },
                      child: const Text("Try Again"))
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}

bool correct(Question question, String letterAnswer) {
  if (question.answers[letterAnswer] == null) {
    return false;
  }
  return question.correct == letterAnswer;
}
