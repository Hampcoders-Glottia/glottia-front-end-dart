import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/venue/venue_bloc.dart';

class CreateVenueScreen extends StatefulWidget {
  final int partnerId; // <--- Recibe el ID real

  const CreateVenueScreen({super.key, required this.partnerId});

  @override
  State<CreateVenueScreen> createState() => _CreateVenueScreenState();
}

class _CreateVenueScreenState extends State<CreateVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  // ... otros controllers (state, postalCode) si los tienes en UI

  // Valores por defecto para simplificar demo
  final String _defaultState = "Lima";
  final String _defaultZip = "15001";
  int _selectedTypeId = 2; // Restaurant por defecto

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<VenueBloc>().add(
        CreateVenuePressed(
          name: _nameController.text,
          street: _streetController.text,
          city: _cityController.text,
          country: _countryController.text,
          state: _defaultState, // O agregar campo
          postalCode: _defaultZip, // O agregar campo
          venueTypeId: _selectedTypeId,
          partnerId: widget.partnerId, // <--- USO DEL ID REAL
        ),
      );
      Navigator.pop(context); // Cierra la pantalla tras enviar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Nuevo Local")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre del Local"),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: "Dirección (Calle y Número)"),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: "Ciudad"),
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: "País"),
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedTypeId,
                decoration: const InputDecoration(labelText: "Tipo de Local"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Coworking")),
                  DropdownMenuItem(value: 2, child: Text("Restaurante")),
                  DropdownMenuItem(value: 3, child: Text("Cafetería")),
                ],
                onChanged: (v) => setState(() => _selectedTypeId = v!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Registrar Local", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}