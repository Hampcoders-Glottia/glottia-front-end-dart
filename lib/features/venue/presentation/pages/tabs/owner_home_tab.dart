import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_state.dart';
import '../../bloc/venue/venue_bloc.dart';
import '../create_venue_screen.dart';
import '../promotions_list_screen.dart';
// Imports de widgets 
import '../../widgets/kpi_card.dart';
import '../../widgets/financial_card.dart';
import '../../widgets/quick_action_tile.dart';

class OwnerHomeTab extends StatelessWidget {
  final int partnerId;
  const OwnerHomeTab({super.key, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userName = (authState is AuthSuccess) ? authState.user.name : "Partner";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(userName),
            const SizedBox(height: 25),

            BlocBuilder<VenueBloc, VenueState>(
              builder: (context, state) {
                int activeVenues = 0;
                int totalVenues = 0;
                
                if (state is VenueLoaded) {
                  totalVenues = state.venues.length;
                  activeVenues = state.venues.where((v) => (v['isActive'] ?? false) == true).length;
                }
                
                return Row(
                  children: [
                    Expanded(
                      child: KpiCard(
                        title: "Locales Activos",
                        value: "$activeVenues / $totalVenues",
                        icon: Icons.store,
                        color: kPrimaryBlue,
                        subtitle: "Operativos hoy",
                        isLoaded: state is! VenueLoading,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: KpiCard(
                        title: "Reservas Hoy",
                        value: "0",
                        icon: Icons.calendar_today,
                        color: Colors.orange,
                        subtitle: "Sin actividad reciente",
                        isLoaded: true,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),
            
            const FinancialCard(),
            
            const SizedBox(height: 25),
            const Text("Gestión Rápida", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 15),
            
            BlocBuilder<VenueBloc, VenueState>(
              builder: (context, state) {
                int? firstVenueId;
                int? partnerId; 
                
                if (state is VenueLoaded && state.venues.isNotEmpty) {
                   final firstVenue = state.venues.first;
                   dynamic venueIdField = firstVenue['venueId'];
                   
                   if (venueIdField is int) {
                      firstVenueId = venueIdField;
                   } else if (venueIdField is Map) {
                      firstVenueId = venueIdField['venueId']; 
                   }
                   if (firstVenueId == null && firstVenue['venue'] is Map) {
                      firstVenueId = firstVenue['venue']['venueId'];
                   }
                   partnerId = firstVenue['partnerVenueRegistryId']; 
                }

                return Column(
                  children: [
                    QuickActionTile(
                      icon: Icons.add_business,
                      color: const Color(0xFF2ECC71),
                      title: "Registrar Nuevo Local",
                      subtitle: "Expande tu negocio agregando una nueva sede",
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<VenueBloc>(), child: CreateVenueScreen(partnerId: partnerId ?? 1)))),
                    ),
                    QuickActionTile(
                      icon: Icons.campaign,
                      color: const Color(0xFF6B5AED),
                      title: "Crear Campaña Rápida",
                      subtitle: "Lanza una promoción para tu local principal",
                      onTap: () {
                        if (firstVenueId != null) {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionsListScreen(venueId: firstVenueId!, partnerId: partnerId ?? 1)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registra un local primero")));
                        }
                      },
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kPrimaryBlue, width: 2)),
          child: const CircleAvatar(radius: 24, backgroundColor: Colors.white, backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png")),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bienvenido de nuevo,", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,4))]),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 26, color: Colors.black87)),
        )
      ],
    );
  }
}