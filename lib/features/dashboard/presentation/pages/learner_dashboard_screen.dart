import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/encounter.dart'; // Importamos la entidad correcta

class LearnerDashboardScreen extends StatefulWidget {
  const LearnerDashboardScreen({super.key});

  @override
  State<LearnerDashboardScreen> createState() => _LearnerDashboardScreenState();
}

class _LearnerDashboardScreenState extends State<LearnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos los datos al iniciar la pantalla
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator(color: kPrimaryBlue));
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            } else if (state is DashboardLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. HEADER
                    _buildHeader(),
                    
                    const SizedBox(height: 30),

                    // 2. TARJETAS DE PROGRESO (Actualizadas con LoyaltyStats)
                    Row(
                      children: [
                        Expanded(
                          child: _ProgressCard(
                            label: 'Puntos Totales', // Cambio de etiqueta
                            value: state.stats.points.toString(), // Nueva propiedad
                            icon: Icons.stars, // Icono más relevante para puntos
                            color: const Color(0xFFE3F2FD),
                            iconColor: kPrimaryBlue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ProgressCard(
                            label: 'Clases Asistidas', // Cambio de etiqueta
                            value: state.stats.encountersAttended.toString(), // Nueva propiedad
                            icon: Icons.people_alt,
                            color: const Color(0xFFFFF3E0),
                            iconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 3. BOTÓN DE EXPLORAR
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navegar a pantalla de búsqueda
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: kPrimaryBlue.withOpacity(0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.explore, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Explorar Encuentros",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // 4. LISTA DE PRÓXIMAS RESERVAS
                    const Text(
                      "Próximos Encuentros",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (state.reservations.isEmpty)
                      _buildEmptyState()
                    else
                      ...state.reservations.map((encounter) => _ReservationCard(encounter: encounter)),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey,
          // Puedes cambiar esto por una imagen real o un asset local
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), 
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hola, Estudiante", // Podrías sacar el nombre del AuthBloc si lo necesitas
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Nivel: B1 (Intermedio)", // Hardcoded por ahora o traer del perfil
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 28),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: const [
          Icon(Icons.event_busy, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No hay encuentros programados",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Widget Interno: Tarjeta de Progreso (Sin cambios mayores, solo uso de datos)
class _ProgressCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _ProgressCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24, // Un poco más grande para resaltar los números
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Interno: Tarjeta de Reserva (Adaptado a la entidad Encounter)
class _ReservationCard extends StatelessWidget {
  final Encounter encounter; // Usamos la entidad Encounter

  const _ReservationCard({required this.encounter});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM • h:mm a', 'es_ES'); // Requiere inicializar locale si usas 'es_ES'

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Imagen del local (Placeholder por ahora ya que Encounter no trae imagen)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: Icon(Icons.store, color: Colors.grey[400], size: 40),
            ),
          ),
          const SizedBox(width: 16),
          
          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del Local
                Text(
                  encounter.venueName, 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Fecha y Hora
                Text(
                  dateFormat.format(encounter.scheduledAt),
                  style: const TextStyle(
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Topic y Lenguaje
                Row(
                  children: [
                    const Icon(Icons.topic_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${encounter.topic} (${encounter.language})",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Chip de estado pequeño
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              encounter.status, // Ej: "READY"
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}