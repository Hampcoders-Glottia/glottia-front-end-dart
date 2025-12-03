import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/injection_container.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../bloc/encounter/encounter_bloc.dart';
import '../widgets/counter_stepper.dart';
import '../widgets/custom_dropdown.dart';

class CreateEncounterScreen extends StatelessWidget {
  final int learnerId;
  final Map<String, dynamic> venue; // Recibimos el objeto venue completo

  const CreateEncounterScreen({
    super.key,
    required this.learnerId,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EncounterBloc>(),
      child: _CreateEncounterView(learnerId: learnerId, venue: venue),
    );
  }
}

class _CreateEncounterView extends StatefulWidget {
  final int learnerId;
  final Map<String, dynamic> venue;

  const _CreateEncounterView({required this.learnerId, required this.venue});

  @override
  State<_CreateEncounterView> createState() => _CreateEncounterViewState();
}

class _CreateEncounterViewState extends State<_CreateEncounterView> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();

  // Estado del formulario
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1)).copyWith(hour: 18, minute: 0);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  int _guestCount = 4; // Por defecto según backend minCapacity
  String _selectedLanguageLabel = 'Inglés';
  String _selectedLevel = 'B1';

  // Mapeo para el backend
  final Map<String, String> _languageMap = {
    'Inglés': 'ENGLISH',
    'Español': 'SPANISH',
    'Francés': 'FRENCH',
    'Alemán': 'GERMAN',
    'Italiano': 'ITALIAN',
    'Portugués': 'PORTUGUESE',
  };

  final List<String> _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  void initState() {
    super.initState();
    // Ajustar fecha inicial si es tarde
    if (_selectedDate.hour > 21) {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
      _selectedTime = const TimeOfDay(hour: 10, minute: 0);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      print('Evento CreateEncounterPressed enviado con topic: ${_topicController.text}'); // Agregar aquí
      context.read<EncounterBloc>().add(CreateEncounterPressed(
        creatorId: widget.learnerId,
        venueId: widget.venue['venueId'],
        topic: _topicController.text,
        language: _languageMap[_selectedLanguageLabel]!,
        level: _selectedLevel,
        date: _selectedDate,
        time: _selectedTime,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos datos del usuario actual para pre-llenar contacto
    final authState = context.read<AuthBloc>().state;
    String userName = "Usuario";
    String userEmail = "correo@ejemplo.com";

    if (authState is AuthSuccess) {
      userName = authState.user.name;
      userEmail = authState.user.email;
    } else if (authState is AuthRegistered) {
      userName = authState.user.name;
      userEmail = authState.user.email;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text("Nueva Reserva", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {})
        ],
      ),
      body: BlocListener<EncounterBloc, EncounterState>(
        listener: (context, state) {
          if (state is EncounterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Reserva confirmada!"), backgroundColor: Colors.green),
            );
            // Volver al home y recargar
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false, arguments: widget.learnerId);
          } else if (state is EncounterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. TARJETA DEL LOCAL (Header)
              _buildVenueHeader(),

              // 2. FORMULARIO
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fecha y Hora
                      const Text("Fecha y Hora", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildDatePicker(context)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTimePicker(context)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Número de Personas (Visual, el backend usa defaults por ahora)
                      const Text("Número de Personas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      CounterStepper(
                        value: _guestCount,
                        min: 4, // Mínimo del backend
                        max: 6, // Máximo del backend
                        onChanged: (val) => setState(() => _guestCount = val),
                      ),

                      const SizedBox(height: 24),

                      // Preferencias de Mesa (Mapeadas a Idioma/Nivel)
                      const Text("Preferencias de Aprendizaje", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            CustomDropdown(
                              label: "Idioma a practicar",
                              value: _selectedLanguageLabel,
                              items: _languageMap.keys.toList(),
                              onChanged: (v) => setState(() => _selectedLanguageLabel = v!),
                            ),
                            const SizedBox(height: 10),
                            CustomDropdown(
                              label: "Nivel objetivo",
                              value: _selectedLevel,
                              items: _levels,
                              onChanged: (v) => setState(() => _selectedLevel = v!),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Solicitudes Especiales (Mapeado a Topic)
                      const Text("Tema de Conversación", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _topicController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Ej: Quiero practicar vocabulario de negocios...",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (v) => v!.isEmpty ? "El tema es obligatorio" : null,
                      ),

                      const SizedBox(height: 24),

                      // Información de Contacto (Read Only)
                      const Text("Información del Contacto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            _buildReadOnlyField("Nombre Completo", userName),
                            const Divider(height: 20),
                            _buildReadOnlyField("Correo electrónico", userEmail),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Botón Confirmar
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: BlocBuilder<EncounterBloc, EncounterState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: (state is EncounterLoading) ? null : _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: (state is EncounterLoading)
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Confirmar Reserva", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets de Construcción ---

  Widget _buildVenueHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Imagen del local
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.venue['name'] ?? 'Nombre del Local',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.venue['street']}, ${widget.venue['city']}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(" (124 reseñas)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("FECHA", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: kPrimaryBlue),
                const SizedBox(width: 8),
                Text(DateFormat('dd MMM yyyy', 'es_ES').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: _selectedTime);
        if (picked != null) setState(() => _selectedTime = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("HORA", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: kPrimaryBlue),
                const SizedBox(width: 8),
                Text(_selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade300),
      ],
    );
  }
}