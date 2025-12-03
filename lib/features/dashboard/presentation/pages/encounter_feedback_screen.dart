import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../../domain/entities/encounter.dart';

class EncounterFeedbackScreen extends StatefulWidget {
  final Encounter encounter;
  const EncounterFeedbackScreen({super.key, required this.encounter});

  @override
  State<EncounterFeedbackScreen> createState() => _EncounterFeedbackScreenState();
}

class _EncounterFeedbackScreenState extends State<EncounterFeedbackScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  
  // Tags para feedback rápido
  final List<String> _tags = ["Divertido", "Buen Nivel", "Puntual", "Inspirador", "Mala Conexión"];
  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Calificar Clase", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar o Icono del Venue
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kPrimaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.store_mall_directory_rounded, size: 40, color: kPrimaryBlue),
            ),
            const SizedBox(height: 16),
            Text(
              "¿Qué tal estuvo tu sesión en\n${widget.encounter.venueName}?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.encounter.topic,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            
            const SizedBox(height: 40),
            
            // Estrellas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() => _rating = index + 1);
                  },
                );
              }),
            ),
            
            const SizedBox(height: 30),
            
            // Tags
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: kPrimaryBlue.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? kPrimaryBlue : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selected ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 30),
            
            // Comentario
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Cuéntanos más sobre tu experiencia (opcional)",
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón Enviar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _rating > 0 ? () {
                  // TODO: Llamar al backend para enviar feedback
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Gracias por tu feedback!"))
                  );
                } : null, // Deshabilitado si no hay rating
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Enviar Opinión", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}