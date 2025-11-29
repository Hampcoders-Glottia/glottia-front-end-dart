import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../bloc/venue/venue_bloc.dart';
import '../create_venue_screen.dart';
import '../../widgets/owner_venue_card.dart'; // Importamos el widget extraído

class OwnerVenuesTab extends StatelessWidget {
  final int partnerId;
  const OwnerVenuesTab({super.key, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Mis Locales", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.refresh, color: kPrimaryBlue),
            onPressed: () => context.read<VenueBloc>().add(LoadPartnerVenues(partnerId)),
          ),
        ],
      ),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryBlue));
          } else if (state is VenueLoaded) {
            if (state.venues.isEmpty) return _buildEmptyState();
            
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.venues.length,
              separatorBuilder: (c, i) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final venueReg = state.venues[index];
                // Usamos el widget refactorizado
                return OwnerVenueCard(
                  venueReg: venueReg, 
                  partnerId: partnerId
                );
              },
            );
          } else if (state is VenueError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VenueBloc>(),
                child: CreateVenueScreen(partnerId: partnerId),
              ),
            ),
          );
        },
        backgroundColor: kPrimaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nuevo Local", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_mall_directory_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No tienes locales registrados", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }
}