import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/promotion/promotion_bloc.dart';

class CreatePromotionScreen extends StatefulWidget {
  final int venueId;
  const CreatePromotionScreen({super.key, required this.venueId});

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<PromotionBloc>().add(CreatePromotionSubmitted(
        venueId: widget.venueId,
        name: _nameCtrl.text,
        description: _descCtrl.text,
        discount: double.parse(_discountCtrl.text),
        startDate: _startDate,
        endDate: _endDate,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Promoción")),
      body: BlocListener<PromotionBloc, PromotionState>(
        listener: (context, state) {
          if (state is PromotionCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Promoción creada!")));
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: "Título de la promoción", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Campo requerido" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: "Descripción", border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _discountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Porcentaje de Descuento (%)", border: OutlineInputBorder(), suffixText: "%"),
                  validator: (v) => v!.isEmpty ? "Requerido" : null,
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Fecha Inicio"),
                  trailing: Text(_startDate.toString().substring(0,10)),
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                    if (d != null) setState(() => _startDate = d);
                  },
                ),
                ListTile(
                  title: const Text("Fecha Fin"),
                  trailing: Text(_endDate.toString().substring(0,10)),
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: _endDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                    if (d != null) setState(() => _endDate = d);
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue),
                    child: const Text("Crear Promoción", style: TextStyle(color: Colors.white)),
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