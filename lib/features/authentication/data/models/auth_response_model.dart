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
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [id, username, token];
}