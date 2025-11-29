import 'package:flutter/material.dart';

class VenueCard extends StatelessWidget {
  final dynamic venue; // Idealmente usa tu modelo VenueModel aquí
  final VoidCallback onTap;

  const VenueCard({
    super.key,
    required this.venue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN DEL LOCAL
            Container(
              height: 160,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  // Placeholder: puedes cambiar esto por venue.imageUrl si lo tienes
                  image: NetworkImage("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Badge de Rating
                  Positioned(
                    bottom: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(" (25+)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  // Badge de Tipo
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE724C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Restaurante", // Podrías usar venue.type
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // INFORMACIÓN
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue['name'] ?? 'Nombre desconocido', // Manejo seguro de nulos
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          // Ajusta según la estructura de tu JSON/Modelo
                          "${venue['street'] ?? ''}, ${venue['city'] ?? ''}", 
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(Icons.table_restaurant, size: 16, color: Color(0xFFFE724C)),
                      SizedBox(width: 6),
                      Text("Mesas disponibles", style: TextStyle(color: Color(0xFFFE724C), fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}