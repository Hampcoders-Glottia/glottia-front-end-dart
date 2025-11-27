import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/create_encounter_screen.dart';
import '../../domain/entities/encounter.dart';
import '../../domain/entities/loyalty_stats.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';

class LearnerDashboardScreen extends StatefulWidget {
  final int learnerId;
  const LearnerDashboardScreen({super.key, required this.learnerId});

  @override
  State<LearnerDashboardScreen> createState() => _LearnerDashboardScreenState();
}

class _LearnerDashboardScreenState extends State<LearnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo gris muy suave
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: kPrimaryBlue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Bienvenido de nuevo",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "Estudiante", // Aquí podrías poner el nombre real si lo tienes en el estado
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryBlue));
          } else if (state is DashboardError) {
            return _buildErrorState(state.message);
          } else if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId)),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Tarjeta de Puntos (Gamificación)
                    _LoyaltyCard(stats: state.stats),
                    
                    const SizedBox(height: 25),

                    // 2. Título de Sección
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tus Próximas Clases",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {}, // Navegar a historial completo
                          child: const Text("Ver todas"),
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 10),

                    // 3. Lista de Encuentros
                    if (state.reservations.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.reservations.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          return _EncounterCard(encounter: state.reservations[index]);
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      // Botón Flotante para Acción Principal
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Pasamos el learnerId a la pantalla de creacion
           final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateEncounterScreen(learnerId: widget.learnerId),
            ),
          );
           if (result == true) {
            context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId));
           }
        },
        backgroundColor: kPrimaryBlue,
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text("Reservar Mesa", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          TextButton(
            onPressed: () => context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId)),
            child: const Text("Reintentar"),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: const [
          Icon(Icons.calendar_today_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 15),
          Text(
            "No tienes clases programadas",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            "¡Reserva una mesa para practicar!",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS INTERNOS ---

class _LoyaltyCard extends StatelessWidget {
  final LoyaltyStats stats;

  const _LoyaltyCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A6FA5), Color(0xFF6B8DD6)], // Tonos de tu kPrimaryBlue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tus Puntos Glottia",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Text(
                "${stats.points}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Nivel: Principiante", // Placeholder, backend podría enviarlo
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}

class _EncounterCard extends StatelessWidget {
  final Encounter encounter;

  const _EncounterCard({required this.encounter});

  @override
  Widget build(BuildContext context) {
    // Formateadores de fecha
    final dateStr = DateFormat('d MMM', 'es_ES').format(encounter.scheduledAt);
    final timeStr = DateFormat('h:mm a').format(encounter.scheduledAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Columna de Fecha
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  dateStr.split(' ')[0], // Día
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 20, 
                    color: kPrimaryBlue
                  ),
                ),
                Text(
                  dateStr.split(' ')[1].toUpperCase(), // Mes
                  style: const TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.w600, 
                    color: kPrimaryBlue
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  encounter.topic,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.translate, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${encounter.language} • ${encounter.venueName}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      timeStr,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Icono de Estado o Flecha
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}