import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/login_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/register_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/welcome_screen.dart';
import 'package:mobile_frontend/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:mobile_frontend/config/injection_container.dart' as di;

void main() async{

  // 1. Aseguramos que el motor de Flutter esté listo para operaciones asíncronas antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ¡Inicializamos el contenedor de dependencias!
  // Esto registra todos tus BloCs, Repositorios y Casos de Uso en GetIt
  await di.init();

  // 3. Ahora sí, arrancamos la app
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
    Widget build(BuildContext context) {
      return MultiBlocProvider(
        // Inyectamos el AuthBloc aquí para que esté disponible en TODA la app
        providers: [
          BlocProvider(
            create: (_) => di.sl<AuthBloc>(), 
          ),
        ],
        child: MaterialApp(
          title: 'Glottia',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'Roboto', // O la fuente que uses
          ),
        // 🚀 AQUÍ ESTÁ LA CLAVE: Definimos la ruta inicial
          initialRoute: '/welcome', 
        
        // Definimos el mapa de navegación
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const DashboardScreen(), // A donde van al loguearse
        },
      ),
    );
  }
}