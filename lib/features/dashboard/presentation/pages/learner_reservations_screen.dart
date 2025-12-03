import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/encounter_feedback_screen.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../widgets/encounter_card.dart';
import '../widgets/skeleton_loading.dart';

class LearnerReservationsScreen extends StatefulWidget {
  final int learnerId;
  const LearnerReservationsScreen({super.key, required this.learnerId});

  @override
  State<LearnerReservationsScreen> createState() => _LearnerReservationsScreenState();
}

class _LearnerReservationsScreenState extends State<LearnerReservationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Cargamos datos al entrar si no están cargados
    context.read<DashboardBloc>().add(LoadDashboardData(widget.learnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Mis Reservas", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: kPrimaryBlue,
          tabs: const [
            Tab(text: "Próximas"),
            Tab(text: "Historial"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(isHistory: false), // Pestaña Próximas
          _buildList(isHistory: true),  // Pestaña Historial
        ],
      ),
    );
  }

// Widget reutilizable para ambas listas
  Widget _buildList({required bool isHistory}) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Padding(padding: EdgeInsets.all(20), child: SkeletonLoading());
        } else if (state is DashboardLoaded) {
          // ✅ Seleccionamos la lista correcta según la pestaña
          final encounters = isHistory ? state.history : state.reservations;
          
          if (encounters.isEmpty) {
            return _buildEmptyState(
              isHistory ? "No tienes clases pasadas" : "No tienes próximas clases",
              isHistory ? Icons.history : Icons.calendar_today_outlined,
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: encounters.length,
            itemBuilder: (context, index) {
              return EncounterCard(
                encounter: encounters[index],
                onTap: isHistory ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> EncounterFeedbackScreen(encounter: encounters[index])));
                } : null,
                );
            },
          );
        } else if (state is DashboardError) {
           return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }
}