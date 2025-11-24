import 'package:equatable/equatable.dart';

class AuthResponseModel extends Equatable {
  final int id;
  final String username;
  final String token;

  const AuthResponseModel({
    required this.id,
    required this.username,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['id'] as int,
      username: json['username'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, username, token];
}