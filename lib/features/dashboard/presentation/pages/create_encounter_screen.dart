import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../../../config/injection_container.dart';
import '../bloc/encounter/encounter_bloc.dart';

class CreateEncounterScreen extends StatelessWidget {
  const CreateEncounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el BLoC aquí mismo para que la pantalla sea autónoma
    return BlocProvider(
      create: (_) => sl<EncounterBloc>(),
      child: const _CreateEncounterView(),
    );
  }
}

class _CreateEncounterView extends StatefulWidget {
  const _CreateEncounterView();

  @override
  State<_CreateEncounterView> createState() => _CreateEncounterViewState();
}

class _CreateEncounterViewState extends State<_CreateEncounterView> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  
  // Valores por defecto
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 00);
  String _selectedLanguage = 'ENGLISH'; // Debe coincidir con tu backend enum
  String _selectedLevel = 'A1';        // Debe coincidir con tu backend enum
  // Listas para Dropdowns (Basadas en tu Backend)
  final List<String> _languages = ['ENGLISH', 'SPANISH', 'FRENCH', 'GERMAN', 'ITALIAN', 'PORTUGUESE'];
  final List<String> _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<EncounterBloc>().add(
        CreateEncounterPressed(
          date: _selectedDate,
          time: _selectedTime,
          topic: _topicController.text,
          language: _selectedLanguage,
          level: _selectedLevel,
          venueId: 1, // Hardcoded por ahora como acordamos
          creatorId: 1, // Aquí deberías obtener el ID real del usuario logueado
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Nueva Reserva de Clase", style: TextStyle(color: Colors.black87, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryBlue),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<EncounterBloc, EncounterState>(
        listener: (context, state) {
          if (state is EncounterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Reserva creada con éxito!"), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true); // Regresa y avisa que se actualice
          } else if (state is EncounterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card de Información del Local (Estática por ahora)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.store, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Café Central", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Av. Larco 123 • Lima", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Selectores de Fecha y Hora
                  const Text("¿Cuándo quieres practicar?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _DateTimePicker(
                          icon: Icons.calendar_today,
                          value: DateFormat('dd MMM yyyy').format(_selectedDate),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (date != null) setState(() => _selectedDate = date);
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _DateTimePicker(
                          icon: Icons.access_time,
                          value: _selectedTime.format(context),
                          onTap: () async {
                            final time = await showTimePicker(context: context, initialTime: _selectedTime);
                            if (time != null) setState(() => _selectedTime = time);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text("Detalles de la Clase", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),

                  // Campo Tema
                  TextFormField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      labelText: "Tema de Conversación",
                      hintText: "Ej. Viajes, Comida, Negocios",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (v) => v!.isEmpty ? "El tema es obligatorio" : null,
                  ),
                  const SizedBox(height: 20),

                  // Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedLanguage,
                          decoration: InputDecoration(
                            labelText: "Idioma",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                          onChanged: (v) => setState(() => _selectedLanguage = v!),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedLevel,
                          decoration: InputDecoration(
                            labelText: "Nivel",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                          onChanged: (v) => setState(() => _selectedLevel = v!),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Botón Confirmar
                  BlocBuilder<EncounterBloc, EncounterState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: (state is EncounterLoading) ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                          ),
                          child: (state is EncounterLoading)
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Confirmar Reserva", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _DateTimePicker({required this.icon, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: kPrimaryBlue),
            const SizedBox(width: 10),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}