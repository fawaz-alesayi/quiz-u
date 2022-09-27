import 'package:flutter/widgets.dart';
import 'package:quiz_u_client/models/quiz.dart';
import 'package:http/http.dart' as http;

Future<Quiz?> getQuiz({required String token}) async {
  final url = Uri.parse('https://quizu.okoul.com/Questions');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode < 300) {
    try {
      var questions = Quiz.fromApiJson(response.body);
      return questions;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  } else {
    debugPrint("Error from $url: ${response.statusCode}");
    return null;
  }
}
