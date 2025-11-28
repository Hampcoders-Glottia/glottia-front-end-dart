import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// BLoCs
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/restaurant/presentation/bloc/venue/venue_bloc.dart';

// Pages
// Authentication pages
import 'package:mobile_frontend/features/authentication/presentation/pages/language_selection_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/login_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/register_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/welcome_screen.dart';

// Dashboard pages
import 'package:mobile_frontend/features/dashboard/presentation/pages/learner_navigation_screen.dart';

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
        
        onGenerateRoute: (settings) {
          switch (settings.name) {
            
            // --- RUTAS DE AUTENTICACIÓN ---
            case '/welcome':
              return MaterialPageRoute(builder: (_) => const WelcomeScreen());
            
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());
            
            // Ahora LanguageSelectionScreen requiere un learnerId
            case '/language_selection':
              final args = settings.arguments as int?;
              if (args == null) return _errorRoute("Falta el Learner ID para selección de idioma");
              
              return MaterialPageRoute(
                builder: (_) => LanguageSelectionScreen(learnerId: args),
              );

            // --- RUTAS PRINCIPALES (DASHBOARDS) ---

            case '/home': // Dashboard del Learner (Aprendiz)
              final args = settings.arguments as int?; 
              if (args == null) return _errorRoute("Falta el Learner ID");
              
              // Navegamos al LearnerNavigationScreen
              // Nota: Ya no envolvemos en DashboardBloc aquí, porque las sub-pantallas
              // (como LearnerHomeScreen) manejan sus propios BLoCs (EncounterBloc).
              return MaterialPageRoute(
                builder: (_) => LearnerNavigationScreen(learnerId: args),
              );

            case '/owner_dashboard': // Dashboard del Partner (Dueño de local)
              final args = settings.arguments as int?;
              if (args == null) return _errorRoute("Falta el Partner ID");
              
              return MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<VenueBloc>(),
                  child: OwnerDashboardScreen(partnerId: args),
                ),
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