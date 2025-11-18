import '../../domain/entities/user.dart';

// Este Modelo "extiende" la Entidad de Dominio
class ProfileModel extends User {
  const ProfileModel({
    required String id,
    required String email,
    required String nombre,
    // (Puedes añadir más campos del ProfileResource si los necesitas)
  }) : super(id: id, email: email, nombre: nombre);

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      email: json['email'],
      nombre: json['firstName'], // Tu backend usa 'firstName'
    );
  }

  // Método para convertir nuestros datos de registro a JSON para el POST
  static Map<String, dynamic> registerToJson({
    required String firstName,
    required String lastName,
    required String email,
    // (Tu backend espera 'age' y 'businessRole', los omitiremos por ahora)
  }) {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': 18, // TODO: Añadir esto a la UI de registro
      'businessRole': 'LEARNER', // TODO: Asumir 'LEARNER' por defecto
    };
  }
}