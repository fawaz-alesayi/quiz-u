import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:quiz_u_client/models/quiz.dart';

Future<ProfileResponse?> getProfile({required String token}) async {
  final url = Uri.parse('https://quizu.okoul.com/UserInfo');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode < 300) {
    try {
      var questions = ProfileResponse.fromJson(response.body);
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

class ProfileResponse {
  String mobile;
  String name;

  ProfileResponse({
    required this.mobile,
    required this.name,
  });

  ProfileResponse copyWith({
    String? mobile,
    String? name,
  }) {
    return ProfileResponse(
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobile': mobile,
      'name': name,
    };
  }

  factory ProfileResponse.fromMap(Map<String, dynamic> map) {
    return ProfileResponse(
      mobile: map['mobile'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileResponse.fromJson(String source) =>
      ProfileResponse.fromMap(json.decode(source));

  @override
  String toString() => 'ProfileResponse(mobile: $mobile, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileResponse &&
        other.mobile == mobile &&
        other.name == name;
  }

  @override
  int get hashCode => mobile.hashCode ^ name.hashCode;
}
