import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_event.dart';

class OwnerProfileTab extends StatelessWidget {
  final int partnerId;
  const OwnerProfileTab({super.key, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Color(0xFFF5F6F8), child: Icon(Icons.person, size: 50, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Partner Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("ID: $partnerId", style: TextStyle(color: Colors.grey)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFEBEE), elevation: 0),
                icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                label: const Text("Cerrar Sesión", style: TextStyle(color: Color(0xFFD32F2F))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}