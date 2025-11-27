import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/language_selection_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/login_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/register_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/welcome_screen.dart';
import 'package:mobile_frontend/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/create_encounter_screen.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/learner_dashboard_screen.dart';
import 'package:mobile_frontend/config/injection_container.dart' as di;
import 'package:mobile_frontend/features/restaurant/presentation/bloc/venue/venue_bloc.dart';
import 'package:mobile_frontend/features/restaurant/presentation/pages/owner_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Glottia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          
          '/language_selection': (context) => const LanguageSelectionScreen(),
          
          // Learner routes
          '/home': (context) => BlocProvider(
            create: (_) => di.sl<DashboardBloc>(), // Crea el BLoC usando GetIt
            child: const LearnerDashboardScreen(), // Muestra la vista del Aprendiz
          ),

          // Partner routes
          "/owner_dashboard" : (context) => BlocProvider(
            create: (_) => di.sl<VenueBloc>(),
            child: const OwnerDashboardScreen(partnerId: 0), // Placeholder - se pasa el real desde login
          ),

          '/create_encounter': (context) => const CreateEncounterScreen(),
        },
      ),
    );
  }
}