import '../../domain/entities/user.dart';

// UserModel - Modelo para respuestas de autenticación
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      name: json['name'] ?? json['firstName'] ?? '', // Flexible con el nombre del campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
    };
  }
}

// ProfileModel - Modelo para operaciones de perfil
class ProfileModel extends User {
  const ProfileModel({
    required super.id,
    required super.username,
    required super.name,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      username: json['email'],
      name: json['firstName'], // Tu backend usa 'firstName'
    );
  }

  // Método para convertir nuestros datos de registro a JSON para el POST
  static Map<String, dynamic> registerToJson({
    required String firstName,
    required String lastName,
    required String username,
    required String businessRole,
    // (Tu backend espera 'age' y 'businessRole', los omitiremos por ahora)
  }) {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': username,
      'age': 18, // TODO: Añadir esto a la UI de registro
      'businessRole': businessRole, // TODO: Asumir 'LEARNER' por defecto
    };
  }
}