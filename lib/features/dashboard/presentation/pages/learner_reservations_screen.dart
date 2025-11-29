import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injection_container.dart';
import '../bloc/encounter/encounter_bloc.dart';
import '../../domain/entities/encounter.dart';

class LearnerReservationsScreen extends StatelessWidget {
  final int learnerId;

  const LearnerReservationsScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Cargar reservas al entrar
      create: (_) => sl<EncounterBloc>()..add(LoadMyReservations(learnerId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Mis Reservas", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: false, // Sin flecha atrás en navegación principal
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<EncounterBloc, EncounterState>(
          builder: (context, state) {
            if (state is EncounterLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFE724C)));
            } else if (state is MyReservationsLoaded) {
              if (state.encounters.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.encounters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return _buildReservationCard(state.encounters[index]);
                },
              );
            } else if (state is EncounterFailure) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildReservationCard(Encounter encounter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Fecha grande (Estilo Ticket)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFE724C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  encounter.scheduledAt.day.toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFE724C)),
                ),
                const Text("DIC", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFE724C))),
              ],
            ),
          ),
          const SizedBox(width: 15),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  encounter.topic,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${encounter.language} • Nivel ${encounter.topic}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${encounter.scheduledAt.hour}:00",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // Estado (Badge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Text(
              "Confirmado",
              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text("No tienes reservas activas", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}