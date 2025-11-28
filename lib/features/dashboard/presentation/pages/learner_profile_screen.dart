import 'package:flutter/material.dart';

class LearnerProfileScreen extends StatelessWidget {
  final int learnerId;
  const LearnerProfileScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 10),
              const Text("Learner", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Tarjeta de Puntos
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFE724C), Color(0xFFFF8E6E)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.white, size: 40),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Mis Puntos Glottia", style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text("0 pts", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}