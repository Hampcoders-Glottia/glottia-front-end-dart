import 'package:flutter/material.dart';

class LearnerReservationsScreen extends StatelessWidget {
  final int learnerId;
  const LearnerReservationsScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reservas"), automaticallyImplyLeading: false),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("No tienes reservas activas", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}