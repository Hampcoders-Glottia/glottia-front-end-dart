import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injection_container.dart';
import '../bloc/encounter/encounter_bloc.dart';
import '../../domain/entities/encounter.dart';
import '../../../venue/presentation/pages/venue_selection_screen.dart';

class LearnerHomeScreen extends StatelessWidget {
  final int learnerId;
  const LearnerHomeScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EncounterBloc>()..add(const SearchEncountersRequested()),
      child: _LearnerHomeView(learnerId: learnerId),
    );
  }
}

class _LearnerHomeView extends StatefulWidget {
  final int learnerId;
  const _LearnerHomeView({required this.learnerId});

  @override
  State<_LearnerHomeView> createState() => _LearnerHomeViewState();
}

class _LearnerHomeViewState extends State<_LearnerHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CABECERA PERSONALIZADA
            // Aquí integramos la ubicación y el botón de crear
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ubicación actual", 
                        style: TextStyle(color: Colors.grey, fontSize: 12)
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Color(0xFFFE724C), size: 20),
                          SizedBox(width: 4),
                          Text(
                            "Lima, Perú", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                        ],
                      ),
                    ],
                  ),
                  // BOTÓN DE ACCIÓN (Sustituye al FAB)
                  _buildCreateAction(),
                ],
              ),
            ),

            // 2. FILTROS (Categorías)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildCategoryChip("🍽️ Restaurantes", true),
                  _buildCategoryChip("☕ Cafeterías", false),
                  _buildCategoryChip("🗣️ English Club", false),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Título de la sección
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Encuentros cerca de ti",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            // 3. LISTA DE ENCUENTROS (BLoC)
            Expanded(
              child: BlocBuilder<EncounterBloc, EncounterState>(
                builder: (context, state) {
                  if (state is EncounterLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFFE724C)));
                  } else if (state is EncounterFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is EncounterSearchSuccess) {
                    if (state.encounters.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: state.encounters.length,
                      itemBuilder: (context, index) {
                        return _buildEncounterCard(state.encounters[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildCreateAction() {
    return InkWell(
      onTap: () {
        // Navegar a la Pantalla 2: Selección de Local
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VenueSelectionScreen(
              learnerId: widget.learnerId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: const Icon(Icons.add, color: Color(0xFFFE724C)),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFE724C) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        boxShadow: isSelected ? [
          BoxShadow(color: const Color(0xFFFE724C).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
        ] : [],
      ),
      child: Text(
        label, 
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget _buildEncounterCard(Encounter encounter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200, 
            blurRadius: 15, 
            offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen (Placeholder colorido)
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              color: Colors.grey.shade100, 
              image: const DecorationImage(
                image: NetworkImage("https://img.freepik.com/free-photo/people-taking-part-business-event_23-2149346630.jpg"), 
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${encounter.language} • ${encounter.topic}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  encounter.topic, 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      encounter.scheduledAt.toString().substring(0, 10), // Formato simple por ahora
                      style: const TextStyle(color: Colors.grey, fontSize: 13)
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      encounter.scheduledAt.toString().substring(11, 16), // Hora
                      style: const TextStyle(color: Colors.grey, fontSize: 13)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text("No hay encuentros hoy", style: TextStyle(color: Colors.grey.shade500)),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () {
              // Recargar
              context.read<EncounterBloc>().add(const SearchEncountersRequested());
            }, 
            child: const Text("Intentar de nuevo", style: TextStyle(color: Color(0xFFFE724C)))
          )
        ],
      ),
    );
  }
}