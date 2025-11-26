import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/venue/venue_bloc.dart';


class CreateVenueScreen extends StatefulWidget {
  final int partnerId;
  const CreateVenueScreen({super.key, required this.partnerId});

  @override
  State<CreateVenueScreen> createState() => _CreateVenueScreenState();
}

class _CreateVenueScreenState extends State<CreateVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  
  int _selectedType = 1; // Default 1: COWORKING, 2: RESTAURANT, 3: CAFE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Nuevo Local")),
      body: BlocListener<VenueBloc, VenueState>(
        listener: (context, state) {
          if (state is VenueCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Local creado exitosamente!"), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          }
          if (state is VenueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: "Nombre del Local", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Requerido" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(labelText: "Dirección", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Requerido" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(labelText: "Ciudad", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Requerido" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: "Tipo de Local", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Coworking")),
                    DropdownMenuItem(value: 2, child: Text("Restaurante")),
                    DropdownMenuItem(value: 3, child: Text("Café")),
                  ],
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<VenueBloc>().add(CreateVenuePressed(
                          partnerId: widget.partnerId,
                          name: _nameCtrl.text,
                          address: _addressCtrl.text,
                          city: _cityCtrl.text,
                          venueTypeId: _selectedType
                        ));
                      }
                    },
                    child: const Text("Guardar Local", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}