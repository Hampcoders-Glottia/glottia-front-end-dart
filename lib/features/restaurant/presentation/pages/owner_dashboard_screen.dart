import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

import '../bloc/venue/venue_bloc.dart';
import 'create_venue_screen.dart'; 

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  // TODO: Obtener ID real del Profile/Auth BLoC. 
  // Como hicimos el fix de "hardcode", usa el ID de tu partner creado.
  final int _currentPartnerId = 1; 

  @override
  void initState() {
    super.initState();
    context.read<VenueBloc>().add(LoadPartnerVenues(_currentPartnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Mis Locales", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kPrimaryBlue),
            onPressed: () => context.read<VenueBloc>().add(LoadPartnerVenues(_currentPartnerId)),
          )
        ],
      ),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VenueLoaded) {
            if (state.venues.isEmpty) return _buildEmptyState();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venueReg = state.venues[index]; 
                // El endpoint retorna VenueRegistrationResource
                // Estructura aprox: {id, venueId, ...} - Ajustar según respuesta real
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kPrimaryBlue.withOpacity(0.1),
                      child: const Icon(Icons.store, color: kPrimaryBlue),
                    ),
                    title: Text("Local ID: ${venueReg['venueId']}"),
                    subtitle: Text("Registrado: ${venueReg['registrationDate']?.substring(0,10)}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VenueBloc>(),
                child: CreateVenueScreen(partnerId: _currentPartnerId),
              ),
            ),
          );
        },
        backgroundColor: kPrimaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nuevo Local", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_mall_directory_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("No tienes locales registrados", style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}