import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


Future<LeaderboardResponse?> getLeaderboard({required String token}) async {
  final url = Uri.parse('https://quizu.okoul.com/TopScores');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode < 300) {
    try {
      var leaderboard = LeaderboardResponse.fromJson(response.body);
      return leaderboard;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  } else {
    debugPrint("Error from $url: ${response.statusCode}");
    return null;
  }
}

class LeaderboardResponse {
  List<Score> scores;

  LeaderboardResponse({
    required this.scores,
  });

  LeaderboardResponse copyWith({
    List<Score>? scores,
  }) {
    return LeaderboardResponse(
      scores: scores ?? this.scores,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scores': scores.map((x) => x.toMap()).toList(),
    };
  }

  factory LeaderboardResponse.fromMap(Map<String, dynamic> map) {
    return LeaderboardResponse(
      scores: List<Score>.from(map['scores']?.map((x) => Score.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaderboardResponse.fromJson(String source) {
    final list = json.decode(source) as List;
    return LeaderboardResponse(
      scores: list.map((e) => Score.fromMap(e)).toList(),
    );
  }

  @override
  String toString() => 'LeaderboardResponse(scores: $scores)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is LeaderboardResponse && listEquals(other.scores, scores);
  }

  @override
  int get hashCode => scores.hashCode;
}

class Score {
  String name;
  int score;

  Score({
    required this.name,
    required this.score,
  });

  Score copyWith({
    String? name,
    int? score,
  }) {
    return Score(
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      name: map['name'] ?? '',
      score: map['score']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) => Score.fromMap(json.decode(source));

  @override
  String toString() => 'Score(name: $name, score: $score)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Score && other.name == name && other.score == score;
  }

  @override
  int get hashCode => name.hashCode ^ score.hashCode;
}
