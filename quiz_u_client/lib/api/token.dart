import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<bool> validateToken({required String token}) async {
  final url = Uri.parse('https://quizu.okoul.com/Token');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 401) {
    return false;
  } else if (response.statusCode == 200) {
    return true;
  }
  return false;
}
