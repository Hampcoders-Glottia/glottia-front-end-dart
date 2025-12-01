import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

// BLoC y Entidades
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../../domain/entities/encounter.dart';
import '../../domain/entities/loyalty_stats.dart';

// Pantallas de navegación
import '../../../venue/presentation/pages/venue_selection_screen.dart';
import 'gamification_screen.dart';
import 'encounter_detail_screen.dart';
import 'notification_screen.dart'; // Asegúrate de haber creado este archivo

// Widgets
import '../widgets/skeleton_loading.dart';

class LearnerDashboardScreen extends StatefulWidget {
  final int learnerId;
  const LearnerDashboardScreen({super.key, required this.learnerId});

  @override
  State<LearnerDashboardScreen> createState() => _LearnerDashboardScreenState();
}

class _LearnerDashboardScreenState extends State<LearnerDashboardScreen> {
  // Nota: La carga inicial de datos se maneja preferiblemente en LearnerNavigationScreen
  // para evitar recargas innecesarias al cambiar de pestaña.
  
  void _loadData() {
    context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        color: kPrimaryBlue,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return const SkeletonLoading(); 
                    } else if (state is DashboardError) {
                      return _buildErrorState(state.message);
                    } else if (state is DashboardLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LoyaltyCard(stats: state.stats),
                          const SizedBox(height: 30),
                          const Text(
                            "Tus Próximas Clases",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 15),
                          if (state.reservations.isEmpty)
                            _buildEmptyState()
                          else
                            ...state.reservations.map((e) => _EncounterCard(encounter: e)).toList(),
                          
                          // Espacio extra para que el FAB no tape contenido
                          const SizedBox(height: 80),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VenueSelectionScreen(learnerId: widget.learnerId)),
          ).then((_) => _loadData()); // Recargar al volver
        },
        backgroundColor: kPrimaryBlue,
        label: const Text("Reservar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          "Hola, Estudiante", 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none_rounded, color: Colors.black87, size: 28),
              // Puntito rojo de notificación (simulado)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                ),
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.event_busy, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text("Sin reservas activas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("¡Reserva tu primera mesa hoy!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(message),
          TextButton(onPressed: _loadData, child: const Text("Reintentar"))
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
    // Formateo seguro de fechas
    final day = DateFormat('dd').format(encounter.scheduledAt);
    final month = DateFormat('MMM', 'es_ES').format(encounter.scheduledAt).toUpperCase();
    final time = DateFormat('h:mm a').format(encounter.scheduledAt);

    return GestureDetector(
      onTap: () {
        // Navegación al detalle del encuentro
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EncounterDetailScreen(encounter: encounter)),
        ).then((_) {
          // Opcional: Recargar al volver por si canceló la reserva
          context.read<DashboardBloc>().add(LoadDashboardData(encounter.id)); 
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(encounter.topic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.translate, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text("${encounter.language} - ${encounter.venueName}", style: const TextStyle(color: Colors.grey, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  final LoyaltyStats stats;
  const _LoyaltyCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GamificationScreen(stats: stats)),
        );
      },
      child: Container(
        width: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Text("Nivel Básico", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text("${stats.points}", style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1)),
            const Text("Puntos acumulados", style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}