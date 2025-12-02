import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart'; // Importante: para usar sl()
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart'; // Para el evento Load
import 'learner_dashboard_screen.dart';
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
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      LearnerDashboardScreen(learnerId: widget.learnerId),
      LearnerReservationsScreen(learnerId: widget.learnerId),
      LearnerProfileScreen(learnerId: widget.learnerId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 1. Envolvemos todo en el BlocProvider
    return BlocProvider<DashboardBloc>(
      // 2. Usamos la inyección de dependencias (sl) para crear el Bloc
      // y cargamos los datos INMEDIATAMENTE aquí para que estén listos.
      create: (context) => sl<DashboardBloc>()..add(LoadDashboardData(widget.learnerId)),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: Colors.white,
            indicatorColor: kPrimaryBlue.withOpacity(0.1),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: kPrimaryBlue),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month, color: kPrimaryBlue),
                label: 'Reservas',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: kPrimaryBlue),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}