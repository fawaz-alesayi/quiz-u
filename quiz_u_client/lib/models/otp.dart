import 'dart:convert';

class OTPRequest {
  String otp;
  String mobile;

  OTPRequest({
    required this.otp,
    required this.mobile,
  });

  OTPRequest copyWith({
    String? otp,
    String? mobile,
  }) {
    return OTPRequest(
      otp: otp ?? this.otp,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OTP': otp,
      'mobile': mobile,
    };
  }

  factory OTPRequest.fromMap(Map<String, dynamic> map) {
    return OTPRequest(
      otp: map['OTP'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPRequest.fromJson(String source) =>
      OTPRequest.fromMap(json.decode(source));

  @override
  String toString() => 'OTPRequest(OTP: $otp, mobile: $mobile)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OTPRequest && other.otp == otp && other.mobile == mobile;
  }

  @override
  int get hashCode => otp.hashCode ^ mobile.hashCode;
}

class OTPResponse {
  bool success;
  String userStatus;
  String message;
  String? name;
  String token;
  String? mobile;

  OTPResponse({
    required this.success,
    required this.userStatus,
    required this.message,
    this.name,
    required this.token,
    this.mobile,
  });

  OTPResponse copyWith({
    bool? success,
    String? userStatus,
    String? message,
    String? token,
  }) {
    return OTPResponse(
      success: success ?? this.success,
      userStatus: userStatus ?? this.userStatus,
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'user_status': userStatus,
      'message': message,
      'name': name,
      'token': token,
      'mobile': mobile,
    };
  }

  factory OTPResponse.fromMap(Map<String, dynamic> map) {
    return OTPResponse(
      success: map['success'] ?? false,
      userStatus: map['user_status'] ?? '',
      message: map['message'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPResponse.fromJson(String source) =>
      OTPResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'OTPResponse(success: $success, userStatus: $userStatus, message: $message, token: $token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OTPResponse &&
        other.success == success &&
        other.userStatus == userStatus &&
        other.message == message &&
        other.token == token &&
        other.mobile == mobile &&
        other.name == name;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      userStatus.hashCode ^
      message.hashCode ^
      token.hashCode;
}

abstract class UserStatus {
  static const String NEW = 'new';
  static const String RETURNING = 'returning';
}
