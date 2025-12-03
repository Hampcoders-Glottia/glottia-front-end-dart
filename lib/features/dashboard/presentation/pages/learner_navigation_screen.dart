import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart';
import '../../../../core/network/token_storage.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/encounter/encounter_bloc.dart';
import 'learner_dashboard_screen.dart';
import 'learner_profile_screen.dart';
import 'learner_reservations_screen.dart';
import 'search_encounters_screen.dart';

class LearnerNavigationScreen extends StatefulWidget {
  final int learnerId; // Este puede venir incorrecto del login
  const LearnerNavigationScreen({super.key, required this.learnerId});

  @override
  State<LearnerNavigationScreen> createState() => _LearnerNavigationScreenState();
}

class _LearnerNavigationScreenState extends State<LearnerNavigationScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  final TokenStorage _tokenStorage = sl<TokenStorage>();
  int? _correctLearnerId; // LearnerId obtenido del JWT
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCorrectLearnerId();
  }

  Future<void> _loadCorrectLearnerId() async {
    // Obtener el learnerId correcto del JWT
    final learnerId = await _tokenStorage.getLearnerId();

    if (learnerId != null) {
      setState(() {
        _correctLearnerId = learnerId;
        _isLoading = false;
        // Inicializar páginas con el learnerId correcto
        _pages = [
          LearnerDashboardScreen(learnerId: _correctLearnerId!),
          LearnerReservationsScreen(learnerId: _correctLearnerId!),
          SearchEncountersScreen(learnerId: _correctLearnerId!),
          LearnerProfileScreen(learnerId: _correctLearnerId!),
        ];
      });
    } else {
      // Fallback: usar el learnerId del parámetro si falla la decodificación
      setState(() {
        _correctLearnerId = widget.learnerId;
        _isLoading = false;
        _pages = [
          LearnerDashboardScreen(learnerId: _correctLearnerId!),
          LearnerReservationsScreen(learnerId: _correctLearnerId!),
          SearchEncountersScreen(learnerId: _correctLearnerId!),
          LearnerProfileScreen(learnerId: _correctLearnerId!),
        ];
      });
      print('⚠️ No se pudo obtener learnerId del JWT, usando parámetro: ${widget.learnerId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _correctLearnerId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) => sl<DashboardBloc>()
            ..add(LoadDashboardData(_correctLearnerId!)), // Usar el learnerId correcto
        ),
        BlocProvider<EncounterBloc>(
          create: (context) => sl<EncounterBloc>()
            ..add(LoadEncountersByLearnerRequested(_correctLearnerId!)), // Usar el learnerId correcto
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
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
