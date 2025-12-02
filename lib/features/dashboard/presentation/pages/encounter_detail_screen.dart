import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/check_in_screen.dart';
import '../../domain/entities/encounter.dart';

class EncounterDetailScreen extends StatelessWidget {
  final Encounter encounter;

  const EncounterDetailScreen({super.key, required this.encounter});

  @override
  Widget build(BuildContext context) {
    // Formatos de fecha y hora
    final dateStr = DateFormat(
      'EEEE d, MMMM',
      'es_ES',
    ).format(encounter.scheduledAt);
    final timeStr = DateFormat('h:mm a').format(encounter.scheduledAt);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar con Imagen/Mapa de fondo
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: kPrimaryBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de placeholder para el mapa o el lugar
                  Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=-12.119, -77.029&zoom=15&size=600x400&maptype=roadmap&key=YOUR_API_KEY_HERE', // O una imagen genérica de "Meeting"
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.map,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Gradiente para que el texto se lea bien
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. Contenido Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y Estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          encounter.topic,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStatusChip(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Clase de conversación • ${encounter.level}",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 30),

                  // Información Grid
                  _buildInfoRow(Icons.calendar_today, dateStr, "Fecha"),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.access_time, timeStr, "Hora de inicio"),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.language, encounter.language, "Idioma"),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.people_outline,
                    "${encounter.currentParticipants}/${encounter.maxCapacity} Participantes",
                    "Asistencia",
                  ),

                  const Divider(height: 40),

                  // Sección de Ubicación
                  const Text(
                    "Ubicación",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: kPrimaryBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              encounter.venueName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              encounter.venueAddress,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Botones de Acción
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar lógica de Cancelar Reserva (Llamar al Bloc)
                        _showCancelDialog(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Cancelar Reserva",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckInScreen(encounter: encounter),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code, color: Colors.black87),
                      label: const Text(
                        "Ver Ticket / Check-in",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    // Lógica simple para mostrar el estado
    bool isPast = encounter.scheduledAt.isBefore(DateTime.now());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPast ? Colors.grey.shade200 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPast ? "Finalizado" : "Confirmado",
        style: TextStyle(
          color: isPast ? Colors.grey.shade700 : Colors.green.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, String label) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Cancelar reserva?"),
        content: const Text(
          "Perderás tu lugar en la mesa y no podrás recuperar los puntos de reserva.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Volver"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Aquí dispararías el evento del Bloc para cancelar:
              // context.read<DashboardBloc>().add(CancelEncounter(encounter.id));
              Navigator.pop(context); // Volver al dashboard
            },
            child: const Text(
              "Confirmar Cancelación",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
