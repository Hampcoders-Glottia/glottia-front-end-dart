class UpcomingReservation {
  final String id;
  final String placeName;
  final String address;
  final DateTime date;
  final String imageUrl; // URL de la foto del local

  const UpcomingReservation({
    required this.id,
    required this.placeName,
    required this.address,
    required this.date,
    required this.imageUrl,
  });
}