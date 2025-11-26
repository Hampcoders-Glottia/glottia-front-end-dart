import '../../domain/entities/user.dart';

class ProfileModel extends User {
  final String? businessRole; // 1. Nuevo campo para almacenar el rol

  const ProfileModel({
    required super.id,
    required super.username,
    required super.name,
    this.businessRole, // 2. Agregado al constructor
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      username: json['email'],
      name: json['firstName'],
      businessRole: json['businessRole'], // 3. IMPORTANTE: Mapeamos el rol desde el JSON
    );
  }

  // Método para convertir datos de registro a JSON para el Backend
  static Map<String, dynamic> registerToJson({
    required String firstName,
    required String lastName,
    required String username,
    required String businessRole,
    
    // Campos para Aprendiz (Learner)
    String? street,
    String? number,
    String? city,
    String? postalCode,
    String? country,

    // Campos para Dueño de Local (Partner) - NUEVOS
    String? businessName,
    String? legalName,
    String? taxId,
    String? contactPhone,
    String? description,
  }) {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': username,
      'age': 25, // Edad por defecto técnica
      'businessRole': businessRole,
    };

    // Lógica para APRENDIZ (LEARNER)
    if (businessRole == 'LEARNER') {
      data.addAll({
        'street': street ?? 'Sin Calle',
        'number': number ?? '0',
        'city': city ?? 'Sin Ciudad',
        'postalCode': postalCode ?? '00000',
        'country': country ?? 'Sin Pais',
        'latitude': 0.0,
        'longitude': 0.0,
      });
    }

    // Lógica para DUEÑO DE LOCAL (PARTNER) - Datos Reales
    if (businessRole == 'PARTNER') {
      data.addAll({
        'businessName': businessName,
        'legalName': legalName,
        'taxId': taxId,
        'contactPhone': contactPhone,
        'description': description,
        // Datos complementarios requeridos por el Backend
        'contactEmail': username, // Usamos el mismo email de registro
        'contactPersonName': '$firstName $lastName', // Usamos el nombre del usuario
        'websiteUrl': '', 
        'instagramHandle': '',
      });
    }

    return data;
  }
}