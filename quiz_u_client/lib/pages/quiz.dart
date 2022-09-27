// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/models/quiz.dart';
import 'package:quiz_u_client/pages/home.dart';

const QuizDuration = Duration(seconds: 5);

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
  bool failedQuiz = false;
  Duration quizDuration = QuizDuration;

  /// countdownTimer is only responsible for what happens after the quiz ends
  Timer? countdownTimer;

  QuestionsWidget({Key? key, required this.questions}) : super(key: key);

  @override
  ConsumerState<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends ConsumerState<QuestionsWidget> {
  /// Clock is what drives the re-renders of quizDuration
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
    widget.countdownTimer!.cancel();
  }

  void startTimer({Function? onFinish}) {
    widget.countdownTimer = Timer(widget.quizDuration, () {
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
        widget.countdownTimer!.cancel();
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
    });
    resetTimer();
    startTimer(onFinish: () {
      widget.failedQuiz = true;
      widget.questionIndex = 0;
    });
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Time left: $minutes:$seconds"),
          SizedBox(height: 20),
          Text(widget.questions[widget.questionIndex].question),
          for (var answer
              in widget.questions[widget.questionIndex].answers.entries)
            TextButton(
                onPressed: () {
                  if (correct(
                      widget.questions[widget.questionIndex], answer.key)) {
                    debugPrint(
                        "Answered to question ${widget.questionIndex} correctly");
                    // Move to next question
                    setState(() {
                      widget.questionIndex++;
                      debugPrint("${widget.questionIndex}");
                    });
                  } else {
                    debugPrint(
                        "Answered to question ${widget.questionIndex} incorrectly");
                    setState(() {
                      widget.failedQuiz = true;
                    });
                  }
                },
                child: Text("${answer.key}. ${answer.value}"))
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Wrong Answer. You failed the quiz 😔."),
          TextButton(
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
