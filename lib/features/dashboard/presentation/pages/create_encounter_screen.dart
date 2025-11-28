import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/injection_container.dart';
import '../bloc/encounter/encounter_bloc.dart';
import '../widgets/selection_tile.dart';
import '../widgets/custom_dropdown.dart';

class CreateEncounterScreen extends StatelessWidget {
  final int learnerId;
  final int venueId;

  const CreateEncounterScreen({
    super.key,
    required this.learnerId,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EncounterBloc>(),
      child: _CreateEncounterView(learnerId: learnerId, venueId: venueId),
    );
  }
}

class _CreateEncounterView extends StatefulWidget {
  final int learnerId;
  final int venueId;

  const _CreateEncounterView({required this.learnerId, required this.venueId});

  @override
  State<_CreateEncounterView> createState() => _CreateEncounterViewState();
}

class _CreateEncounterViewState extends State<_CreateEncounterView> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();

  // --- 1. VALORES POR DEFECTO (Strings) ---
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  
  // Selección inicial
  String _selectedLanguageLabel = 'Inglés'; 
  String _selectedLevel = 'B1'; 

  // --- 2. MAPEO: Vista (Español) -> Backend (Códigos String) ---
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
    // Validación: Si es muy tarde hoy, sugerir mañana
    if (_selectedDate.hour > 22) {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Enviamos Strings y objetos Date/Time separados como lo tienes en tu evento
      context.read<EncounterBloc>().add(CreateEncounterPressed(
        creatorId: widget.learnerId,
        venueId: widget.venueId,
        topic: _topicController.text,
        // Convertimos la etiqueta 'Inglés' -> 'ENGLISH'
        language: _languageMap[_selectedLanguageLabel]!, 
        level: _selectedLevel, // Enviamos 'B1' directo
        date: _selectedDate,
        time: _selectedTime,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Reservar Mesa", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<EncounterBloc, EncounterState>(
        listener: (context, state) {
          if (state is EncounterCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Reserva creada con éxito!"), backgroundColor: Colors.green),
            );
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false, arguments: widget.learnerId);
          } else if (state is EncounterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Tema de conversación"),
                const SizedBox(height: 10),
                
                // Campo de Texto (Tema)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: TextFormField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      hintText: "Ej: Viajes, Tecnología, Fútbol...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(Icons.chat_bubble_outline, color: Color(0xFFFE724C)),
                    ),
                    validator: (value) => value!.isEmpty ? "Escribe un tema" : null,
                  ),
                ),

                const SizedBox(height: 25),
                _buildSectionTitle("Detalles del Idioma"),
                const SizedBox(height: 10),

                // Selectores de Idioma y Nivel (Usando CustomDropdown)
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        label: "Idioma",
                        value: _selectedLanguageLabel,
                        items: _languageMap.keys.toList(),
                        onChanged: (val) => setState(() => _selectedLanguageLabel = val!),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomDropdown(
                        label: "Nivel",
                        value: _selectedLevel,
                        items: _levels,
                        onChanged: (val) => setState(() => _selectedLevel = val!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                _buildSectionTitle("¿Cuándo?"),
                const SizedBox(height: 10),

                // Selectores de Fecha y Hora (Usando SelectionTile)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      // Fecha
                      SelectionTile(
                        label: "Fecha",
                        value: DateFormat('EEE, dd MMM yyyy', 'es_ES').format(_selectedDate),
                        icon: Icons.calendar_month,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: const Color(0xFFFE724C),
                                  colorScheme: const ColorScheme.light(primary: Color(0xFFFE724C)),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) setState(() => _selectedDate = date);
                        },
                      ),
                      
                      const Divider(height: 30),
                      
                      // Hora (Con validación de pares)
                      SelectionTile(
                        label: "Hora",
                        value: "${_selectedTime.format(context)} (2 horas)",
                        icon: Icons.access_time_filled,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                            helpText: "HORAS PARES (8:00, 10:00...)",
                          );
                          
                          if (time != null) {
                            int validHour = time.hour;
                            if (validHour % 2 != 0) validHour -= 1; // Forzar par
                            if (validHour < 8) validHour = 8;
                            if (validHour > 22) validHour = 22;

                            setState(() => _selectedTime = TimeOfDay(hour: validHour, minute: 0));
                            
                            if (time.hour != validHour || time.minute != 0) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Hora ajustada a turnos del local (Pares)"),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Botón Confirmar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: BlocBuilder<EncounterBloc, EncounterState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: (state is EncounterLoading) ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFE724C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                          shadowColor: const Color(0xFFFE724C).withOpacity(0.4),
                        ),
                        child: (state is EncounterLoading)
                            ? const SizedBox(
                                height: 24, width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : const Text("Confirmar Reserva", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }
}