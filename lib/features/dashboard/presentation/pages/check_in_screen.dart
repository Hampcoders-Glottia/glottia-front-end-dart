import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Si no lo instalaste, comenta esta línea
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../domain/entities/encounter.dart';

class CheckInScreen extends StatelessWidget {
  final Encounter encounter;

  const CheckInScreen({super.key, required this.encounter});

  @override
  Widget build(BuildContext context) {
    // Generamos un string único para el QR (Ej: encounterID-learnerID)
    final String qrData = "glottia-checkin-${encounter.id}-learner"; 

    return Scaffold(
      backgroundColor: kPrimaryBlue, // Fondo azul para resaltar el ticket blanco
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tu Ticket de Entrada", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- TICKET CARD ---
              ClipPath(
                clipper: TicketClipper(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Header del Ticket
                      Text(
                        encounter.topic.toUpperCase(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${encounter.language} • ${encounter.level}",
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      
                      // Código QR
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: QrImageView( // Usa Icon(Icons.qr_code, size: 200) si no instalaste el paquete
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Muestra este código al llegar",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(thickness: 1, color: Colors.grey), // Línea punteada visual
                      _buildDashedLine(),
                      const SizedBox(height: 24),

                      // Detalles Inferiores
                      _buildDetailRow("FECHA", DateFormat('dd MMM yyyy').format(encounter.scheduledAt)),
                      const SizedBox(height: 16),
                      _buildDetailRow("HORA", DateFormat('h:mm a').format(encounter.scheduledAt)),
                      const SizedBox(height: 16),
                      _buildDetailRow("LUGAR", encounter.venueName),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Botón de Acción Manual
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Aquí conectaremos el Check-in manual por geolocalización
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Check-in manual simulado exitoso! +50 Puntos"))
                  );
                },
                icon: const Icon(Icons.location_on, color: kPrimaryBlue),
                label: const Text("Estoy aquí, hacer Check-in", style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade300),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

// --- Clipper para el efecto de ticket (mordidas a los lados) ---
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    
    // "Mordida" izquierda
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height * 0.65), radius: 20.0));
    // "Mordida" derecha
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height * 0.65), radius: 20.0));

    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}