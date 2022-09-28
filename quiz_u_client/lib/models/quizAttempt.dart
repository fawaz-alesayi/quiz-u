import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:quiz_u_client/models/quiz.dart';

class QuizAttempt {
  DateTime date;
  Quiz quiz;
  List<String> choices;
  int score;

  QuizAttempt({
    required this.date,
    required this.quiz,
    required this.choices,
    required this.score,
  });

  QuizAttempt copyWith({
    DateTime? date,
    Quiz? quiz,
    List<String>? choices,
    int? score,
  }) {
    return QuizAttempt(
      date: date ?? this.date,
      quiz: quiz ?? this.quiz,
      choices: choices ?? this.choices,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'quiz': quiz.toMap(),
      'choices': choices,
      'score': score,
    };
  }

  factory QuizAttempt.fromMap(Map<String, dynamic> map) {
    return QuizAttempt(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      quiz: Quiz.fromMap(map['quiz']),
      choices: List<String>.from(map['choices']),
      score: map['score']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizAttempt.fromJson(String source) =>
      QuizAttempt.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuizAttempt(date: $date, quiz: $quiz, choices: $choices, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is QuizAttempt &&
        other.date == date &&
        other.quiz == quiz &&
        listEquals(other.choices, choices) &&
        other.score == score;
  }

  @override
  int get hashCode {
    return date.hashCode ^ quiz.hashCode ^ choices.hashCode ^ score.hashCode;
  }
}
