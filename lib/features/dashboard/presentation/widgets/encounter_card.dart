import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/encounter.dart';
import '../pages/encounter_detail_screen.dart';

class EncounterCard extends StatelessWidget {
  final Encounter encounter;
  final VoidCallback? onTap; // Para poder hacer click en el futuro

  const EncounterCard({super.key, required this.encounter, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Formateo seguro
    final day = DateFormat('dd').format(encounter.scheduledAt);
    final month = DateFormat('MMM', 'es_ES').format(encounter.scheduledAt).toUpperCase();
    final time = DateFormat('h:mm a').format(encounter.scheduledAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => EncounterDetailScreen(encounter: encounter)
          )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Columna de Fecha
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kPrimaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimaryBlue)),
                  Text(month, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kPrimaryBlue)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Información Principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    encounter.topic,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.translate, "${encounter.language} - ${encounter.venueName}"),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.access_time_filled, time),
                ],
              ),
            ),
            // Icono de estado (opcional)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}