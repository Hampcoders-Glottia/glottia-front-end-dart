import '../../domain/entities/user.dart';

class ProfileModel extends User {

  // IDs adicionales para lógica de negocio (Solución al hardcoding)
  final int? userId;
  final int? learnerId;
  final int? partnerId;

  const ProfileModel({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String userType,
    this.userId,
    this.learnerId,
    this.partnerId,
  }) : super(
    id: id,
    username: email,
    name: '$firstName $lastName',
    email: email,
    firstName: firstName,
    lastName: lastName,
    userType: userType,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userType: json['businessRole'] as String, // Mapeamos el rol desde el JSON del backend
      
      // Capturamos los IDs específicos del rol si vienen en la respuesta
      // (Tu backend ProfileResource los envía como 'learnerId' y 'partnerId' en el nivel raíz)
      learnerId: json['learnerId'] as int?,
      partnerId: json['partnerId'] as int?,
      userId: json['userId'] as int?,
    );
  }

  // Método para convertir datos de registro a JSON para el Backend
  static Map<String, dynamic> registerToJson({
    required String firstName,
    required String lastName,
    required String username, // Email
    required String password, // Agregado porque es necesario para el registro completo
    required String businessRole,
    
    // Campos para Aprendiz (Learner)
    String? street,
    String? number,
    String? city,
    String? postalCode,
    String? country,

    // Campos para Dueño de Local (Partner)
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
      'username': username, // El backend IAM suele pedir username y password también en el DTO compuesto
      'password': password,
      'age': 25, // Edad por defecto técnica (o agregar campo al formulario si es necesario)
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

    // Lógica para DUEÑO DE LOCAL (PARTNER)
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
        'subscriptionStatusId': 2, // 2 = ACTIVE (asumiendo ID por defecto para pruebas)
      });
    }

    return data;
  }
  
  // Método auxiliar para crear una copia con userId inyectado (útil si viene del login separado)
  ProfileModel copyWithUserId(int userId) {
    return ProfileModel(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      userType: userType,
      learnerId: learnerId,
      partnerId: partnerId,
      userId: userId,
    );
  }
}