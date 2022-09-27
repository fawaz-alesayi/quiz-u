import 'package:flutter/widgets.dart';
import 'package:quiz_u_client/models/otp.dart';
import 'package:http/http.dart' as http;

Future<OTPResponse?> login({otp, phoneNumber}) async {
  var otpRequest = OTPRequest(mobile: phoneNumber, otp: otp);
  // make a POST request to https://quizu.okoul.com/Login with otpRequest as payload
  // if the response is 201 and "success" is true, return true
  // else return false
  final url = Uri.parse('https://quizu.okoul.com/Login');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: otpRequest.toJson(),
  );

  if (response.statusCode == 201) {
    try {
      var otpResponse = OTPResponse.fromJson(response.body);
      if (otpResponse.success) {
        return otpResponse;
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
