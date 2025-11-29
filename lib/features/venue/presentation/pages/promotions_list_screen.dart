import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart';
import '../bloc/promotion/promotion_bloc.dart';
import 'create_promotion_screen.dart';

class PromotionsListScreen extends StatelessWidget {
  final int venueId; 
  final int partnerId;

  const PromotionsListScreen({super.key, required this.venueId, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PromotionBloc>()..add(LoadVenuePromotions(venueId)),
      child: _PromotionsListView(venueId: venueId, partnerId: partnerId),
    );
  }
}
  
class _PromotionsListView extends StatelessWidget {
  final int venueId;
  final int partnerId;
  const _PromotionsListView({required this.venueId, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Fondo gris muy claro
      appBar: AppBar(
        title: const Text("Campañas Activas", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocBuilder<PromotionBloc, PromotionState>(
        builder: (context, state) {
          if (state is PromotionLoading) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryBlue));
          } else if (state is PromotionLoaded) {
            if (state.promotions.isEmpty) {
              return _buildEmptyState(context);
            }
            // Usamos ListView con Padding para que respire
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: state.promotions.length,
              separatorBuilder: (c, i) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final promo = state.promotions[index];
                return _buildPromotionCard(promo);
              },
            );
          } else if (state is PromotionError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
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
                value: context.read<PromotionBloc>(),
                child: CreatePromotionScreen(venueId: venueId, partnerId: partnerId),
              ),
            ),
          );
        },
        backgroundColor: kPrimaryBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Crear Campaña", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPromotionCard(dynamic promo) {
    // Formateo de fecha
    final dateFormat = DateFormat('d MMM', 'es_ES');
    final dateRange = "${dateFormat.format(promo.startDate)} - ${dateFormat.format(promo.endDate)}";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {}, // Futuro: Ver detalles
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Columna Izquierda: Porcentaje (Badge visual)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB74D), Color(0xFFF57C00)], // Naranja degradado
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${promo.discountPercentage.toInt()}%",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
                      ),
                      const Text(
                        "OFF",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Columna Central: Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 8),
                      // Etiqueta de fecha
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F3F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_filled, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(dateRange, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                // Columna Derecha: Menu
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_outlined, size: 60, color: kPrimaryBlue),
          ),
          const SizedBox(height: 24),
          const Text(
            "Sin promociones activas",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Crea tu primera campaña para atraer más estudiantes a tu local.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}