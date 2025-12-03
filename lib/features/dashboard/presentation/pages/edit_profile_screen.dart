import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  // Aquí podrías recibir el objeto User actual
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores (Idealmente vendrían llenos con datos del AuthBloc)
  final _nameController = TextEditingController(text: "Estudiante Glottia");
  final _bioController = TextEditingController(text: "Me encanta aprender idiomas y conocer gente nueva.");
  String _selectedLevel = "Básico";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Disparar evento UpdateProfile en AuthBloc
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Perfil actualizado correctamente"))
                );
              }
            },
            child: const Text("Guardar", style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto de Perfil
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF0F2F5),
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: kPrimaryBlue, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              
              _buildTextField("Nombre Completo", _nameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField("Biografía", _bioController, Icons.info_outline, maxLines: 3),
              const SizedBox(height: 20),
              
              // Dropdown de Nivel
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: InputDecoration(
                  labelText: "Nivel de Inglés",
                  prefixIcon: const Icon(Icons.school_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ["Básico", "Intermedio", "Avanzado"].map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (val) => setState(() => _selectedLevel = val!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Este campo no puede estar vacío" : null,
    );
  }
}