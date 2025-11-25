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
    String? street,
    String? number,
    String? city,
    String? postalCode,
    String? country,
  }) {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': username,
      'age': 25, // Edad hardcodeada válida (Backend requiere int)
      'businessRole': businessRole,
    };

    // ¡OJO AQUÍ! Esta es la parte que fallaba.
    // El backend lanza excepción si street es null.
    // Enviamos la data SI el rol es LEARNER.
    if (businessRole == 'LEARNER') {
      data['street'] = street ?? 'Sin Calle';
      data['number'] = number ?? '0';
      data['city'] = city ?? 'Sin Ciudad';
      data['postalCode'] = postalCode ?? '00000';
      data['country'] = country ?? 'Sin Pais';
      data['latitude'] = 0.0;
      data['longitude'] = 0.0;
    }
    
    // Si es PARTNER, añadimos datos dummy de negocio para que no falle
    if (businessRole == 'PARTNER') {
       data['legalName'] = '$firstName $lastName Enterprise';
       data['businessName'] = '$firstName\'s Place';
       data['taxId'] = '${DateTime.now().millisecondsSinceEpoch}'; // Tax ID único temporal
       data['contactEmail'] = username;
       data['contactPhone'] = '999999999';
       data['contactPersonName'] = '$firstName $lastName';
       data['description'] = 'Nuevo local registrado desde la app';
    }

    return data;
  }
}