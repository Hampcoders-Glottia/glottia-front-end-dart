import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_event.dart';

import '../bloc/venue/venue_bloc.dart';
import 'create_venue_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  // 1. Declaramos la variable del ID del partner
  final int partnerId;

  // 2. Actualizamos el constructor para recibirla obligatoriamente
  const OwnerDashboardScreen({super.key, required this.partnerId});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos los locales al iniciar la pantalla
    context.read<VenueBloc>().add(LoadPartnerVenues(widget.partnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo gris claro moderno
      appBar: AppBar(
        title: const Text(
          "Mis Locales",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // Botón de Refrescar
          IconButton(
            icon: const Icon(Icons.refresh, color: kPrimaryBlue),
            onPressed: () => context.read<VenueBloc>().add(LoadPartnerVenues(widget.partnerId)),
          ),
          // Botón de Cerrar Sesión
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryBlue));
          } else if (state is VenueLoaded) {
            if (state.venues.isEmpty) return _buildEmptyState();
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venueReg = state.venues[index];
                // Nota: Asegúrate que tu VenueBloc esté mapeando correctamente el JSON
                // Si venueReg es un Map<String, dynamic>:
                final venueId = venueReg['venueId'] ?? 'ID Desconocido';
                // Si el JSON viene con un objeto anidado 'venue', ajusta aquí: venueReg['venue']['name']
                final date = venueReg['registrationDate']?.toString().substring(0, 10) ?? 'N/A';
                final isActive = venueReg['isActive'] ?? false;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: isActive ? kPrimaryBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      child: Icon(
                        Icons.store, 
                        color: isActive ? kPrimaryBlue : Colors.grey
                      ),
                    ),
                    title: Text(
                      "Local #$venueId", 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Registrado: $date"),
                        Text(
                          isActive ? "Activo" : "Inactivo",
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      // TODO: Aquí navegaremos al 'Dashboard Detallado' (Figma) del local específico
                      // Navigator.push(...);
                    },
                  ),
                );
              },
            );
          } else if (state is VenueError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: () => context.read<VenueBloc>().add(LoadPartnerVenues(widget.partnerId)),
                    child: const Text("Reintentar"),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegamos a la pantalla de creación
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VenueBloc>(), // Pasamos el Bloc existente para recargar al volver
                child: CreateVenueScreen(partnerId: widget.partnerId),
              ),
            ),
          ).then((_) {
            // Recargamos la lista al volver de la creación
            context.read<VenueBloc>().add(LoadPartnerVenues(widget.partnerId));
          });
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
          const SizedBox(height: 24),
          Text(
            "No tienes locales registrados",
            style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Crea tu primer local para comenzar",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}