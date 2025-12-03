import '../../domain/entities/encounter.dart';

class EncounterModel extends Encounter {
  const EncounterModel({
    required super.id,
    required super.topic,
    required super.language,
    required super.level,
    required super.scheduledAt,
    required super.venueName,
    required super.venueAddress,
    super.currentParticipants,
    required super.maxCapacity,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parseo seguro con validaciones
      final venueNameRaw = json['venueName']?.toString() ?? '';
      final venueAddressRaw = json['venueAddress']?.toString() ?? '';

      // Si el backend envía "string" literal, usar valores por defecto
      final venueName = (venueNameRaw.isEmpty || venueNameRaw == 'string')
          ? 'Ubicación sin nombre'
          : venueNameRaw;

      final venueAddress = (venueAddressRaw.isEmpty || venueAddressRaw == 'string')
          ? 'Dirección no disponible'
          : venueAddressRaw;

      return EncounterModel(
        id: json['id'] as int? ?? 0,
        topic: (json['topic']?.toString() ?? 'Sin tema').trim(),
        language: (json['language']?.toString() ?? 'N/A').trim(),
        level: (json['level']?.toString() ?? 'N/A').trim(),
        scheduledAt: json['scheduledAt'] != null
            ? DateTime.parse(json['scheduledAt'].toString())
            : DateTime.now(),
        venueName: venueName,
        venueAddress: venueAddress,
        currentParticipants: (json['attendances'] as List<dynamic>?)?.length ?? 0,
        maxCapacity: json['maxCapacity'] as int? ?? 4,
      );
    } catch (e, stackTrace) {
      print('❌ Error parseando EncounterModel: $e');
      print('📄 JSON recibido: $json');
      print('📚 Stack trace: $stackTrace');

      // Retornar un modelo por defecto en caso de error crítico
      return EncounterModel(
        id: json['id'] as int? ?? 0,
        topic: 'Error al cargar',
        language: 'N/A',
        level: 'N/A',
        scheduledAt: DateTime.now(),
        venueName: 'Error',
        venueAddress: '',
        currentParticipants: 0,
        maxCapacity: 4,
      );
    }
  }
}