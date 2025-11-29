import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/venue/venue_bloc.dart';
import '../widgets/input_decoration.dart';

class CreateVenueScreen extends StatefulWidget {
  final int partnerId;

  const CreateVenueScreen({super.key, required this.partnerId});

  @override
  State<CreateVenueScreen> createState() => _CreateVenueScreenState();
}

class _CreateVenueScreenState extends State<CreateVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para los campos del formulario
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  // Campos adicionales con valores por defecto para simplificar (puedes agregar inputs si quieres)
  final String _defaultState = "Lima"; 
  final String _defaultZip = "15001";
  
  // Valor inicial para el dropdown (2 = Restaurante)
  int _selectedTypeId = 2; 

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() {
    // Ocultar teclado
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // Disparar evento al BLoC
      context.read<VenueBloc>().add(
        CreateVenuePressed(
          name: _nameController.text.trim(),
          street: _streetController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          state: _defaultState,
          postalCode: _defaultZip,
          venueTypeId: _selectedTypeId,
          partnerId: widget.partnerId, // Usamos el ID real que recibimos
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Nuevo Local"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: BlocConsumer<VenueBloc, VenueState>(
        // Listener: Para efectos secundarios (Navegación, Snackbars)
        listener: (context, state) {
          if (state is VenueLoaded) { 
            // Asumimos que si vuelve a VenueLoaded después de Loading es porque tuvo éxito
            // O si implementaste VenueOperationSuccess, usa ese estado
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("¡Local registrado exitosamente!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(); // Regresar al Dashboard
          } else if (state is VenueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        // Builder: Para reconstruir la UI (Loading spinner)
        builder: (context, state) {
          final isLoading = state is VenueLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Información del Establecimiento",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBlue),
                  ),
                  const SizedBox(height: 20),

                  // Nombre del Local
                  TextFormField(
                    controller: _nameController,
                    decoration: buildInputDecoration("Nombre del Local", Icons.store),
                    textInputAction: TextInputAction.next,
                    validator: (v) => v!.isEmpty ? "El nombre es obligatorio" : null,
                  ),
                  const SizedBox(height: 15),

                  // Tipo de Local (Dropdown)
                  DropdownButtonFormField<int>(
                    value: _selectedTypeId,
                    decoration: buildInputDecoration("Tipo de Negocio", Icons.category),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Coworking Space")),
                      DropdownMenuItem(value: 2, child: Text("Restaurante")),
                      DropdownMenuItem(value: 3, child: Text("Cafetería")),
                    ],
                    onChanged: (v) => setState(() => _selectedTypeId = v!),
                  ),
                  
                  const SizedBox(height: 30),
                  const Text(
                    "Ubicación",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBlue),
                  ),
                  const SizedBox(height: 20),

                  // Dirección
                  TextFormField(
                    controller: _streetController,
                    decoration: buildInputDecoration("Calle y Número", Icons.location_on),
                    textInputAction: TextInputAction.next,
                    validator: (v) => v!.isEmpty ? "La dirección es obligatoria" : null,
                  ),
                  const SizedBox(height: 15),

                  // Ciudad y País (En fila)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: buildInputDecoration("Ciudad", Icons.location_city),
                          textInputAction: TextInputAction.next,
                          validator: (v) => v!.isEmpty ? "Requerido" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _countryController,
                          decoration: buildInputDecoration("País", Icons.public),
                          textInputAction: TextInputAction.done,
                          validator: (v) => v!.isEmpty ? "Requerido" : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24, width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              "Guardar Local",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  
}