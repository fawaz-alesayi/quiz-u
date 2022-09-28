import 'dart:convert';

class User {
  String token;
  String? name;
  String mobile;

  User({
    required this.token,
    required this.name,
    required this.mobile,
  });

  User copyWith({
    String? token,
    String? name,
    String? mobile,
  }) {
    return User(
      token: token ?? this.token,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'name': name,
      'mobile': mobile,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'] ?? '',
      name: map['name'],
      mobile: map['mobile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(token: $token, name: $name, mobile: $mobile)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.token == token &&
        other.name == name &&
        other.mobile == mobile;
  }

  @override
  int get hashCode => token.hashCode ^ name.hashCode ^ mobile.hashCode;
}
