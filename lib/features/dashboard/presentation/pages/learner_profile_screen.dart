import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'edit_profile_screen.dart';

class LearnerProfileScreen extends StatelessWidget {
  final int learnerId;
  const LearnerProfileScreen({super.key, required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildOptionsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: kPrimaryBlue,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            "Estudiante Glottia",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "estudiante@glottia.com",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Chip(
            label: const Text("Nivel Básico"),
            backgroundColor: kPrimaryBlue.withOpacity(0.1),
            labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard("Clases", "12", Icons.class_outlined)),
          const SizedBox(width: 15),
          Expanded(child: _buildStatCard("Puntos", "450", Icons.emoji_events_outlined)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimaryBlue, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildOptionTile("Editar Perfil", Icons.edit_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const EditProfileScreen()));
          }),
          _buildOptionTile("Preferencias de Idioma", Icons.language, () {}),
          _buildOptionTile("Notificaciones", Icons.notifications_none, () {}),
          _buildOptionTile("Ayuda y Soporte", Icons.help_outline, () {}),
          const SizedBox(height: 20),
          _buildOptionTile(
            "Cerrar Sesión", 
            Icons.logout, 
            () {
              // Lógica de logout (AuthBloc)
              Navigator.of(context).pushReplacementNamed('/login');
            },
            isDestructive: true
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : Colors.black87, size: 20),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: isDestructive ? Colors.red : Colors.black87
          )
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}