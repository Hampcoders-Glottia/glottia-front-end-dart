import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injection_container.dart';
import '../../../dashboard/presentation/pages/create_encounter_screen.dart';
import '../bloc/venue/venue_bloc.dart';
import '../widgets/venue_card.dart'; 

class VenueSelectionScreen extends StatelessWidget {
  final int learnerId;

  const VenueSelectionScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VenueBloc>()..add(LoadAllVenues()), 
      child: _VenueSelectionView(learnerId: learnerId),
    );
  }
}

class _VenueSelectionView extends StatefulWidget {
  final int learnerId;
  const _VenueSelectionView({required this.learnerId});

  @override
  State<_VenueSelectionView> createState() => _VenueSelectionViewState();
}

class _VenueSelectionViewState extends State<_VenueSelectionView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Elige un lugar", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda (Podrías extraerla también si quieres)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<VenueBloc, VenueState>(
              builder: (context, state) {
                if (state is VenueLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFE724C)));
                } else if (state is VenueError) {
                  return Center(child: Text(state.message));
                } else if (state is VenueLoaded) {
                  if (state.venues.isEmpty) {
                    return const Center(child: Text("No hay locales disponibles"));
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.venues.length,
                    itemBuilder: (context, index) {
                      final venue = state.venues[index];
                      
                      // WIDGET EXTRAÍDO
                      return VenueCard(
                        venue: venue,
                        onTap: () {
                          // La navegación se define aquí, manteniendo el widget puro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateEncounterScreen(
                                learnerId: widget.learnerId,
                                venue: venue, 
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}