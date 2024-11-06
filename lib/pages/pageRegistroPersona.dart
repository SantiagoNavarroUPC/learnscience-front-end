import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:get/get.dart';
import '../components/coustom_bottom_nav_bar.dart';
import '../controllers/controllerPersona.dart';
import '../controllers/controllerUsuario.dart';
import '../enums.dart';
import '../models/Persona.dart';

class RegistroPersonaScreen extends StatefulWidget {
  const RegistroPersonaScreen({super.key});

  @override
  _RegistroPersonaScreenState createState() => _RegistroPersonaScreenState();
}

class _RegistroPersonaScreenState extends State<RegistroPersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final PersonaController personaController = Get.put(PersonaController());
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  final UsuarioController usuarioController = Get.find<UsuarioController>();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadPersonaData();
  }

  Future<void> _loadPersonaData() async {
    final idUsuario = usuarioController.usuario.value?.idUsuario;
    if (idUsuario != null) {
      try {
        PersonaModel? persona = await personaController.obtenerPersonaPorIdUsuario(idUsuario);
        if (persona != null) {
          setState(() {
            cedulaController.text = persona.cedula;
            nombreController.text = persona.nombre;
            apellidoController.text = persona.apellido;
            edadController.text = persona.edad.toString();
            telefonoController.text = persona.telefono.toString();
            direccionController.text = persona.direccion;
          });
        } else {
          Get.snackbar('No te has registrado','Hazlo por favor');
        }
      } catch (e) {
        Get.snackbar('Error', 'No se pudo cargar la persona');
      }
    } else {
      Get.snackbar('Error', 'ID de usuario no disponible');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final idUsuario = usuarioController.usuario.value?.idUsuario;

      if (idUsuario != null) {
        PersonaModel persona = PersonaModel(
          idPersona: idUsuario,
          idUsuario: idUsuario,
          cedula: cedulaController.text,
          nombre: nombreController.text,
          apellido: apellidoController.text,
          edad: int.tryParse(edadController.text) ?? 0,
          telefono: telefonoController.text,
          direccion: direccionController.text,
          eliminado: false,
        );
        bool result = await personaController.guardarPersona(persona);
        if (result) {
          Get.snackbar(
            'Éxito',
            'Datos suministrados correctamente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gColorTheme1_900,
            colorText: Colors.white,
          );
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Get.snackbar(
            'Error',
            'Error al suministrar datos',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gColorThemeError,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Error: Debes autenticarte primero',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_900,
          colorText: Colors.white,
        );
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
          'Datos del usuario',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: Colors.black,
            ),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent, // Color de fondo
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -150,
                  child: Container(
                    width: 250,
                    height: 300,
                    decoration: BoxDecoration(
                      color: gColorTheme1_900.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  right: 280,
                  child: Container(
                    width: 250,
                    height: 300,
                    decoration: BoxDecoration(
                      color: gColorTheme1_700.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Formulario con scroll
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextFormField(
                          controller: cedulaController,
                          label: 'Cédula',
                          icon: Icons.perm_identity,
                          keyboardType: TextInputType.number,
                          enabled: _isEditing,
                        ),
                        _buildTextFormField(
                          controller: nombreController,
                          label: 'Nombre',
                          icon: Icons.person,
                          enabled: _isEditing,
                        ),
                        _buildTextFormField(
                          controller: apellidoController,
                          label: 'Apellido',
                          icon: Icons.person_outline,
                          enabled: _isEditing,
                        ),
                        _buildTextFormField(
                          controller: edadController,
                          label: 'Edad',
                          icon: Icons.cake,
                          keyboardType: TextInputType.number,
                          enabled: _isEditing,
                        ),
                        _buildTextFormField(
                          controller: telefonoController,
                          label: 'Teléfono',
                          icon: Icons.phone,
                          keyboardType: TextInputType.number,
                          enabled: _isEditing,
                        ),
                        _buildTextFormField(
                          controller: direccionController,
                          label: 'Dirección',
                          icon: Icons.location_on,
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isEditing ? _submitForm : null,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Guardar',
                                style: TextStyle(fontSize: 18, color: gColorTheme1_900),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.usuario), 
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: gColorTheme1_900), // Color del borde inferior cuando está enfocado
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          enabled: enabled,
        ),
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $label';
          }
          return null;
        },
        enabled: enabled,
      ),
    );
  }
}

