import 'dart:convert';

import 'package:collection/collection.dart';

class Quiz {
  List<Question> questions;

  Quiz({
    required this.questions,
  });

  Quiz copyWith({
    List<Question>? questions,
  }) {
    return Quiz(
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      questions: List<Question>.from(
          map['questions']?.map((x) => Question.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) => Quiz.fromMap(json.decode(source));

  factory Quiz.fromApi(List<dynamic> list) {
    return Quiz(
      questions: list.map((x) => Question.fromApi(x)).toList(),
    );
  }

  factory Quiz.fromApiJson(String source) => Quiz.fromApi(json.decode(source));

  @override
  String toString() => 'Quiz(questions: $questions)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Quiz && listEquals(other.questions, questions);
  }

  @override
  int get hashCode => questions.hashCode;
}

class Question {
  String question;
  Map<String, String> answers;
  String correct;

  Question({
    required this.question,
    required this.answers,
    required this.correct,
  });

  Question copyWith({
    String? question,
    Map<String, String>? answers,
    String? correct,
  }) {
    return Question(
      question: question ?? this.question,
      answers: answers ?? this.answers,
      correct: correct ?? this.correct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'correct': correct,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      answers: Map<String, String>.from(map['answers']),
      correct: map['correct'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  factory Question.fromApi(Map<String, dynamic> map) {
    return Question(
      question: map['Question'] ?? '',
      answers: {
        'a': map['a'] ?? '',
        'b': map['b'] ?? '',
        'c': map['c'] ?? '',
        'd': map['d'] ?? '',
      },
      correct: map['correct'] ?? '',
    );
  }

  factory Question.fromApiJson(String source) =>
      Question.fromApi(json.decode(source));

  @override
  String toString() =>
      'Question(question: $question, answers: $answers, correct: $correct)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is Question &&
        other.question == question &&
        mapEquals(other.answers, answers) &&
        other.correct == correct;
  }

  @override
  int get hashCode => question.hashCode ^ answers.hashCode ^ correct.hashCode;
}
