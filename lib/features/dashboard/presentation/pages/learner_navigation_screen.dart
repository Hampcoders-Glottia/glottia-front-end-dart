import 'package:flutter/material.dart';
import 'learner_home_screen.dart';
import 'learner_profile_screen.dart';
import 'learner_reservations_screen.dart';

class LearnerNavigationScreen extends StatefulWidget {
  final int learnerId;
  const LearnerNavigationScreen({super.key, required this.learnerId});

  @override
  State<LearnerNavigationScreen> createState() => _LearnerNavigationScreenState();
}

class _LearnerNavigationScreenState extends State<LearnerNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      LearnerHomeScreen(learnerId: widget.learnerId),
      LearnerReservationsScreen(learnerId: widget.learnerId),
      const Center(child: Text("Chat - Próximamente")), // Placeholder
      LearnerProfileScreen(learnerId: widget.learnerId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFE724C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}