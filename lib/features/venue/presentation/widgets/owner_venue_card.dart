import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../pages/promotions_list_screen.dart';

class OwnerVenueCard extends StatelessWidget {
  final dynamic venueReg;
  final int partnerId;

  const OwnerVenueCard({
    super.key,
    required this.venueReg,
    required this.partnerId,
  });

  @override
  Widget build(BuildContext context) {
    // Lógica de extracción de datos segura
    dynamic venueData;
    int venueId = 0;

    if (venueReg['venue'] is Map) {
      venueData = venueReg['venue'];
    } else if (venueReg['venueId'] is Map) {
      venueData = venueReg['venueId'];
    }

    if (venueData != null && venueData['venueId'] is int) {
      venueId = venueData['venueId'];
    } else if (venueReg['venueId'] is int) {
      venueId = venueReg['venueId'];
    }

    final String venueName = venueData != null 
        ? (venueData['name'] ?? "Local #$venueId")
        : "Local #$venueId";
    
    String address = "Dirección no disponible";
    if (venueData != null && venueData['street'] != null) {
      address = "${venueData['street']}, ${venueData['city'] ?? ''}";
    }

    final bool isActive = venueReg['isActive'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: isActive ? kPrimaryBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.store_rounded, color: isActive ? kPrimaryBlue : Colors.grey, size: 28),
            ),
            title: Text(venueName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(address, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            trailing: _buildStatusBadge(isActive),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.campaign_outlined,
                    label: "Promociones",
                    color: Colors.orange,
                    onTap: () {
                      if (venueId == 0) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PromotionsListScreen(
                            venueId: venueId, 
                            partnerId: partnerId
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.grey.shade200),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.table_restaurant_outlined,
                    label: "Mesas",
                    color: kPrimaryBlue,
                    onTap: () {
                        // TODO: Implementar navegación a gestión de mesas
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "Activo" : "Inactivo",
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          fontSize: 11, fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}