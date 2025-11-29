import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

class CounterStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const CounterStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.groups_outlined, color: kPrimaryBlue),
          const SizedBox(width: 10),
          Text(
            "$value invitados",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          _buildButton(
            icon: Icons.remove,
            onTap: () {
              if (value > min) onChanged(value - 1);
            },
          ),
          const SizedBox(width: 10),
          _buildButton(
            icon: Icons.add,
            onTap: () {
              if (value < max) onChanged(value + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kBackgroundGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}