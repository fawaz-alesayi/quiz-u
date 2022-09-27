import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<ScoreResponse?> postScore(
    {required String token, required String score}) async {
  final url = Uri.parse('https://quizu.okoul.com/Score');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({"score": score}),
  );

  if (response.statusCode < 300) {
    try {
      var scoreResponse = ScoreResponse.fromJson(response.body);
      return scoreResponse;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  } else {
    debugPrint("Error from $url: ${response.statusCode}");
    return null;
  }
}

/*
{
  "success": true,
  "message": "User score have been updated"
}
*/
class ScoreResponse {
  bool success;
  String message;

  ScoreResponse({
    required this.success,
    required this.message,
  });

  ScoreResponse copyWith({
    bool? success,
    String? message,
  }) {
    return ScoreResponse(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
    };
  }

  factory ScoreResponse.fromMap(Map<String, dynamic> map) {
    return ScoreResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScoreResponse.fromJson(String source) =>
      ScoreResponse.fromMap(json.decode(source));

  @override
  String toString() => 'ScoreResponse(success: $success, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScoreResponse &&
        other.success == success &&
        other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;
}
