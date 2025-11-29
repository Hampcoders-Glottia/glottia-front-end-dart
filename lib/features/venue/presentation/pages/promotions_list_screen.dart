import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart';
import '../bloc/promotion/promotion_bloc.dart';
import 'create_promotion_screen.dart';

class PromotionsListScreen extends StatelessWidget {
  final int venueId; // Necesitamos saber de qué local son las promociones

  const PromotionsListScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PromotionBloc>()..add(LoadVenuePromotions(venueId)),
      child: _PromotionsView(venueId: venueId),
    );
  }
}

class _PromotionsView extends StatelessWidget {
  final int venueId;
  const _PromotionsView({required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Promociones", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<PromotionBloc, PromotionState>(
        builder: (context, state) {
          if (state is PromotionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromotionLoaded) {
            if (state.promotions.isEmpty) {
              return Center(child: Text("No hay promociones activas"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.promotions.length,
              itemBuilder: (context, index) {
                final promo = state.promotions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withOpacity(0.1),
                      child: const Icon(Icons.local_offer, color: Colors.orange),
                    ),
                    title: Text(promo.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${promo.discountPercentage}% OFF - Hasta: ${promo.endDate.toString().substring(0,10)}"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            );
          } else if (state is PromotionError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navegar a Crear Promoción y pasar el BLoC para recargar al volver
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PromotionBloc>(),
                child: CreatePromotionScreen(venueId: venueId),
              ),
            ),
          );
        },
      ),
    );
  }
}