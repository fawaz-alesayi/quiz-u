import 'dart:convert';

class User {
  String token;
  String name;
  
  User({
    required this.token,
    required this.name,
  });

  User copyWith({
    String? token,
    String? name,
  }) {
    return User(
      token: token ?? this.token,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(token: $token, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.token == token && other.name == name;
  }

  @override
  int get hashCode => token.hashCode ^ name.hashCode;
}
