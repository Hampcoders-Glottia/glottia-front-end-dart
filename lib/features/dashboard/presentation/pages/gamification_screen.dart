import 'package:flutter/material.dart';
import '../../domain/entities/loyalty_stats.dart';

class GamificationScreen extends StatelessWidget {
  final LoyaltyStats stats;

  const GamificationScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Mock de datos para Badges (ya que el backend aún no tiene endpoint de badges)
    final List<Map<String, dynamic>> badges = [
      {'name': 'Primeros Pasos', 'icon': Icons.directions_walk, 'unlocked': true, 'desc': 'Completaste tu primera clase.'},
      {'name': 'Puntual', 'icon': Icons.access_alarm, 'unlocked': true, 'desc': 'Hiciste Check-in a tiempo 3 veces.'},
      {'name': 'Políglota', 'icon': Icons.language, 'unlocked': false, 'desc': 'Participa en clases de 2 idiomas distintos.'},
      {'name': 'Social', 'icon': Icons.people, 'unlocked': false, 'desc': 'Asiste a un evento con más de 5 personas.'},
      {'name': 'Experto', 'icon': Icons.school, 'unlocked': false, 'desc': 'Alcanza el nivel C1.'},
      {'name': 'Viajero', 'icon': Icons.flight_takeoff, 'unlocked': false, 'desc': 'Visita 5 Venues diferentes.'},
    ];

    // Mock de Historial de Puntos
    final List<Map<String, dynamic>> history = [
      {'action': 'Check-in: Starbucks Larcomar', 'points': '+50', 'date': 'Hoy'},
      {'action': 'Reserva completada', 'points': '+100', 'date': 'Ayer'},
      {'action': 'Bono de bienvenida', 'points': '+300', 'date': 'Hace 1 semana'},
    ];

    // Cálculo simple de progreso (Ej: Cada nivel son 1000 puntos)
    double progress = (stats.points % 1000) / 1000;
    int nextLevelPoints = 1000 - (stats.points % 1000);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Mis Logros", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tarjeta de Nivel Principal
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A6FA5), Color(0xFF5B7FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF5B7FFF).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    "Nivel Actual: Básico", // Podrías mapear stats.level aquí
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${stats.points} Puntos Totales",
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  // Barra de Progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Faltan $nextLevelPoints puntos para el siguiente nivel",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
            ),

            // 2. Sección de Medallas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("Medallas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return _buildBadgeItem(context, badge);
              },
            ),

            const SizedBox(height: 30),

            // 3. Historial de Puntos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("Historial de Puntos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.green, size: 20),
                  ),
                  title: Text(item['action'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item['date'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  trailing: Text(
                    item['points'],
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeItem(BuildContext context, Map<String, dynamic> badge) {
    bool isUnlocked = badge['unlocked'];
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(badge['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badge['icon'], size: 50, color: isUnlocked ? Colors.amber : Colors.grey),
                const SizedBox(height: 16),
                Text(badge['desc'], textAlign: TextAlign.center),
                const SizedBox(height: 16),
                if (!isUnlocked)
                  const Text("🔒 Bloqueado", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cerrar"))],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.amber.withOpacity(0.2) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge['icon'],
                color: isUnlocked ? Colors.amber[700] : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.black87 : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}