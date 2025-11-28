import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/injection_container.dart' as di;
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/restaurant/presentation/bloc/venue/venue_bloc.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/create_encounter_screen.dart';

class VenueSelectionScreen extends StatelessWidget {
  final int learnerId;

  const VenueSelectionScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Elige un lugar", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryBlue),
      ),
      body: BlocProvider(
        create: (_) => di.sl<VenueBloc>()..add(LoadAllVenues()), // ¡Carga los locales al abrir!
        child: BlocBuilder<VenueBloc, VenueState>(
          builder: (context, state) {
            if (state is VenueLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueLoaded) {
              if (state.venues.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storefront_sharp, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text("No hay locales disponibles aún."),
                    ],
                  ),
                );
              }
              // LISTA DE LOCALES REALES
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.venues.length,
                itemBuilder: (context, index) {
                  final venue = state.venues[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: kPrimaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.store, color: kPrimaryBlue),
                      ),
                      title: Text(
                        venue['name'] ?? 'Sin nombre',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                         venue['address'] != null 
                          ? "${venue['address']['street']}, ${venue['address']['city']}" 
                          : "Ubicación desconocida",
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kPrimaryBlue),
                      onTap: () {
                        // AL HACER CLIC: Vamos a reservar EN ESTE local específico
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateEncounterScreen(
                              learnerId: learnerId,
                              venueId: venue['venueId'], // PASAMOS EL ID REAL DEL LOCAL
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is VenueError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}