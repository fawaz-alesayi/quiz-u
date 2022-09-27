// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/score.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/models/quiz.dart';
import 'package:quiz_u_client/pages/home.dart';
import 'package:quiz_u_client/pages/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

const QuizDuration = Duration(seconds: 360);

class QuizPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(quizProvider).when(
        loading: () =>
            PageContainer(child: Center(child: CircularProgressIndicator())),
        error: (error, stack) => PageContainer(
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
  int questionIndex = 0;
  int score = 0;
  bool failedQuiz = false;
  Duration quizDuration = QuizDuration;
  bool skipUsed = false;

  /// countdownTimer is only responsible for what happens after the quiz ends
  Timer? quizTimer;

  QuestionsWidget({Key? key, required this.questions}) : super(key: key);

  @override
  ConsumerState<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends ConsumerState<QuestionsWidget> {
  /// Clock is what drives the re-renders of this widget
  Timer? clock;

  @override
  void initState() {
    super.initState();
    startTimer(onFinish: () {
      widget.failedQuiz = true;
      widget.questionIndex = 0;
    });
  }

  /// clear timers when this widget gets removed
  @override
  void dispose() {
    super.dispose();
    clock!.cancel();
    widget.quizTimer!.cancel();
  }

  void startTimer({Function? onFinish}) {
    widget.quizTimer = Timer(widget.quizDuration, () {
      debugPrint("Timer finished");
      if (onFinish != null) {
        onFinish();
      }
    });
    clock = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    setState(() {
      final seconds = widget.quizDuration.inSeconds - 1;
      if (seconds < 0) {
        widget.quizTimer!.cancel();
      } else {
        widget.quizDuration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() => clock!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      widget.quizDuration = QuizDuration;
    });
  }

  void resetQuiz() {
    setState(() {
      widget.failedQuiz = false;
      widget.questionIndex = 0;
      widget.skipUsed = false;
    });
    resetTimer();
    startTimer(onFinish: () {
      widget.failedQuiz = true;
      widget.questionIndex = 0;
    });
  }

  void postResult() async {
    // get shared prefrences
    var pref = await SharedPreferences.getInstance();
    var response = await postScore(
        token: pref.getString('token')!, score: widget.score.toString());
    if (response == null) {
      showErrorSnackBar(
          context, "Sorry, we could not add your score to the leaderbords.");
    } else {
      debugPrint(response.toString());
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

    final minutes = strDigits(widget.quizDuration.inMinutes.remainder(60));
    final seconds = strDigits((widget.quizDuration.inSeconds).remainder(60));
    if (!widget.failedQuiz) {
      if ((widget.questionIndex + 1) > widget.questions.length) {
        stopTimer();
        postResult();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Time left: $minutes:$seconds"),
            SizedBox(height: 20),
            Text("You finished the quiz!"),
            SizedBox(height: 20),
            Text("Your score was ${widget.score}/${widget.questions.length}"),
            TextButton(
                onPressed: () {
                  resetQuiz();
                },
                child: Text("Restart quiz"))
          ],
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Time left: $minutes:$seconds"),
          SizedBox(height: 20),
          Text(widget.questions[widget.questionIndex].question),
          for (var answer
              in widget.questions[widget.questionIndex].answers.entries) ...{
            TextButton(
                onPressed: () {
                  if (correct(
                      widget.questions[widget.questionIndex], answer.key)) {
                    debugPrint(
                        "Answered to question ${widget.questionIndex} correctly");
                    // Move to next question
                    setState(() {
                      widget.score++;
                      widget.questionIndex++;
                    });
                  } else {
                    debugPrint(
                        "Answered to question ${widget.questionIndex} incorrectly");
                    setState(() {
                      widget.failedQuiz = true;
                    });
                  }
                },
                child: Text("${answer.key}. ${answer.value}")),
          },
          if (!widget.skipUsed) ...{
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.skipUsed = true;
                    widget.questionIndex++;
                  });
                },
                child: Text("Skip"))
          }
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Wrong Answer. You failed the quiz 😔."),
          ElevatedButton(
              onPressed: () {
                resetQuiz();
              },
              child: Text("Retry the quiz"))
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
