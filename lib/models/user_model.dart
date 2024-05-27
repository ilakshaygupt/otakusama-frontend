// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String email;
  final String username;
  User({
    required this.email,
    required this.username,
  });

  User copyWith({
    String? email,
    String? username,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(email: $email, username: $username)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.email == email && other.username == username;
  }

  @override
  int get hashCode => email.hashCode ^ username.hashCode;
}
