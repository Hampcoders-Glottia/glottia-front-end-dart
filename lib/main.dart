import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// BLoCs
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:mobile_frontend/features/restaurant/presentation/bloc/venue/venue_bloc.dart';

// Pages
// Authentication pages
import 'package:mobile_frontend/features/authentication/presentation/pages/language_selection_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/login_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/register_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/welcome_screen.dart';
// Dashboard pages
import 'package:mobile_frontend/features/dashboard/presentation/pages/create_encounter_screen.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/learner_dashboard_screen.dart';
// Restaurant pages
import 'package:mobile_frontend/features/restaurant/presentation/pages/owner_dashboard_screen.dart'; 

import 'package:mobile_frontend/config/injection_container.dart' as di;

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
        
        // Usamos onGenerateRoute para manejar argumentos dinámicos
        onGenerateRoute: (settings) {
          switch (settings.name) {
            
            // Rutas simples (sin argumentos)
            case '/welcome':
              return MaterialPageRoute(builder: (_) => const WelcomeScreen());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());
            case '/language_selection':
              // Si language selection necesita el ID para guardarlo luego, habría que pasarlo.
              // Por ahora lo dejamos simple.
              return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());

            // --- RUTAS CON ARGUMENTOS (IDs REALES) ---

            case '/home': // Learner Dashboard
              // Extraemos el argumento que enviamos desde el Login
              final args = settings.arguments as int?; 
              if (args == null) {
                 // Fallback de seguridad por si entramos mal
                 return _errorRoute("Falta el Learner ID");
              }
              return MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<DashboardBloc>(),
                  child: LearnerDashboardScreen(learnerId: args), // Pasamos el ID
                ),
              );

            case '/owner_dashboard': // Partner Dashboard
              final args = settings.arguments as int?;
              if (args == null) return _errorRoute("Falta el Partner ID");
              
              return MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<VenueBloc>(), // Inyectamos VenueBloc aquí
                  child: OwnerDashboardScreen(partnerId: args), // Pasamos el ID
                ),
              );

            case '/create_encounter':
              final args = settings.arguments as int?;
              if (args == null) return _errorRoute("Falta el Creator ID");

              return MaterialPageRoute(
                builder: (_) => CreateEncounterScreen(learnerId: args, venueId: args), // Pasamos el ID
              );

            default:
              return null;
          }
        },
      ),
    );
  }

  // Pantalla de error simple para desarrollo
  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error de Navegación")),
        body: Center(child: Text(message)),
      ),
    );
  }
}