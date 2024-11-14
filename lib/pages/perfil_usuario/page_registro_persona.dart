import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/enums.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/controller_persona.dart';
import '../../controllers/controller_usuario.dart';
import '../../models/persona.dart';

class RegistroPersonaScreen extends StatefulWidget {
  const RegistroPersonaScreen({super.key});

  @override
  _RegistroPersonaScreenState createState() => _RegistroPersonaScreenState();
}

class _RegistroPersonaScreenState extends State<RegistroPersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final PersonaController personaController = Get.put(PersonaController());
  final UsuarioController usuarioController = Get.find<UsuarioController>();

  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  bool _isEditing = false;
  String _profilePhotoUrl = 'https://www.shutterstock.com/image-illustration/photo-silhouette-male-profile-white-260nw-1019597599.jpg';
  bool uploadingImage = false;

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
            _profilePhotoUrl = persona.foto ?? _profilePhotoUrl;
          });
        } else {
          Get.snackbar('No te has registrado', 'Hazlo por favor');
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

  Future<void> _selectImage() async {
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        uploadingImage = true; // Indica que la imagen se está subiendo
      });
      try {
        final idUsuario = usuarioController.usuario.value?.idUsuario;
        if (idUsuario != null) {

          final imageUrl = await _uploadImage(File(pickedImage.path), idUsuario);

          setState(() {
            _profilePhotoUrl = imageUrl; // Actualiza la URL de la foto de perfil
            uploadingImage = false; // Termina el proceso de carga
          });

        } else {
          throw Exception('El ID del usuario no está disponible');
        }

      } catch (e) {
        setState(() {
          uploadingImage = false;
        });
        Get.snackbar('Error', 'Error al cargar la imagen: ${e.toString()}');
      }
    }
  }

  Future<String> _uploadImage(File imageFile, int idUsuario) async {
  try {

    if (imageFile.path.endsWith('.jpg') || 
        imageFile.path.endsWith('.jpeg') || 
        imageFile.path.endsWith('.png')) {

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('fotos_perfil_images')
            .child('$idUsuario.jpg');  // Asegura que se guarde en la carpeta con el nombre de archivo especificado

        // Subir archivo a Firebase Storage
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask;

        // Esperar a que termine la carga y obtener la URL de descarga
        final imageUrl = await snapshot.ref.getDownloadURL();
        _profilePhotoUrl = imageUrl; 
        return _profilePhotoUrl;

      } else {
        throw Exception('El archivo seleccionado no es una imagen válida');
      }
    } on FirebaseException catch (e) {
        throw Exception('Error al cargar la imagen en Firebase Storage: ${e.message}');
      } catch (e) {
        throw Exception('Error al cargar la imagen: ${e.toString()}');
      }
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final idUsuario = usuarioController.usuario.value?.idUsuario;
    if (idUsuario != null) {
      if (_profilePhotoUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'La imagen de perfil no ha sido cargada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      PersonaModel persona = PersonaModel(
        idPersona: idUsuario,
        idUsuario: idUsuario,
        cedula: cedulaController.text,
        nombre: nombreController.text,
        apellido: apellidoController.text,
        edad: int.tryParse(edadController.text) ?? 0,
        telefono: telefonoController.text,
        direccion: direccionController.text,
        foto: _profilePhotoUrl, // Asegura que sea la URL actualizada de la foto
        eliminado: false,
      );

      bool result = await personaController.guardarPersona(persona);

      if (result) {
        setState(() {
          _isEditing = false;
        });
        Get.snackbar(
          'Éxito',
          'Datos suministrados correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Error al suministrar datos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
        Get.snackbar(
          'Error',
          'Debes autenticarte primero',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Datos del usuario',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.black),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo de decorativo
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 115,
                      width: 115,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(_profilePhotoUrl),
                          ),
                          if (_isEditing)
                            Positioned(
                              right: -16,
                              bottom: 0,
                              child: SizedBox(
                                height: 46,
                                width: 46,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: const BorderSide(color: Colors.white),
                                    ),
                                    backgroundColor: const Color(0xFFF5F6F9),
                                  ),
                                  onPressed: _selectImage,
                                  child: const Icon(Icons.camera_alt, color: Colors.black),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Formulario
                  _buildForm(),
                ],
              ),
            ),
          ),
        ],
      ),
       bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.usuario), 
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
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
                color: gColorTheme1_700..withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
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
            borderSide: BorderSide(color: gColorTheme1_600), // Color del borde inferior cuando está enfocado
          ),
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
        ),
        keyboardType: keyboardType,
        enabled: enabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa $label';
          }
          return null;
        },
      ),
    );
  }
}
