import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/encounter/encounter_bloc.dart';
import 'learner_dashboard_screen.dart';
import 'learner_profile_screen.dart';
import 'learner_reservations_screen.dart';
import 'search_encounters_screen.dart';

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
      SearchEncountersScreen(learnerId: widget.learnerId), // NUEVO: tercera posición
      LearnerProfileScreen(learnerId: widget.learnerId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) => sl<DashboardBloc>()
            ..add(LoadDashboardData(widget.learnerId)),
        ),
        BlocProvider<EncounterBloc>(
          create: (context) => sl<EncounterBloc>()
            ..add(LoadEncountersByLearnerRequested(widget.learnerId)),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        // ELIMINADO: floatingActionButtonLocation y floatingActionButton
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 20),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(color: Colors.white);
                  }
                  return const TextStyle(color: Colors.white70);
                }),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const IconThemeData(color: Colors.white);
                  }
                  return const IconThemeData(color: Colors.white);
                }),
              ),
            ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: navBarColor,
            indicatorColor: kPrimaryBlue.withAlpha((0.1 * 255).round()),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: 'Inicio',

              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month, color: Colors.white),
                label: 'Reservas',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search, color: Colors.white),
                label: 'Buscar',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}