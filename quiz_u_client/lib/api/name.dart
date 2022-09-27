import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:quiz_u_client/models/otp.dart';

Future<NewUserNameResponse?> updateName(
    {String? newName, String? token}) async {
  final url = Uri.parse('https://quizu.okoul.com/Name');
  final response = await http.post(url, headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $token',
  }, body: {
    'name': newName,
  });

  if (response.statusCode < 300) {
    try {
      var newNameResponse = NewUserNameResponse.fromJson(response.body);
      if (newNameResponse.success) {
        return newNameResponse;
      } else {
        return null;
      }
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
Convert the following into a dart class
{
  "success": true,
  "message": "User Name has been updated!",
  "name": "Okoul",
  "mobile": "05987654321"
}
*/
class NewUserNameResponse {
  bool success;
  String message;
  String name;
  String mobile;

  NewUserNameResponse({
    required this.success,
    required this.message,
    required this.name,
    required this.mobile,
  });

  NewUserNameResponse copyWith({
    bool? success,
    String? message,
    String? name,
    String? mobile,
  }) {
    return NewUserNameResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'name': name,
      'mobile': mobile,
    };
  }

  factory NewUserNameResponse.fromMap(Map<String, dynamic> map) {
    return NewUserNameResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUserNameResponse.fromJson(String source) =>
      NewUserNameResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewUserNameResponse(success: $success, message: $message, name: $name, mobile: $mobile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewUserNameResponse &&
        other.success == success &&
        other.message == message &&
        other.name == name &&
        other.mobile == mobile;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        message.hashCode ^
        name.hashCode ^
        mobile.hashCode;
  }
}
