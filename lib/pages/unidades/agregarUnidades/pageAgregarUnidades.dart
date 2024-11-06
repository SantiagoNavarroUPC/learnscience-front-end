import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_application/controllers/controllerUnidad.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/controllerUsuario.dart';

class UnidadAdd extends StatefulWidget {
  static String routeName = "/add_unidad";

  @override
  _UnidadAddState createState() => _UnidadAddState();
}

class _UnidadAddState extends State<UnidadAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pdfFile;
  String? _tipo;

  UnidadController controllerUnidad = Get.find<UnidadController>();
  UsuarioController usuarioController = Get.find<UsuarioController>();

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Solo permite archivos PDF
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (!file.path.endsWith('.pdf')) {
          throw Exception('El archivo seleccionado no es un PDF');
        }

        setState(() {
          _pdfFile = file;
        });
      } else {
        throw Exception('No se seleccionó ningún archivo');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<String> _uploadFile(File file) async {
  try {
    if (file.path.endsWith('.pdf')) {
      final storageRef = FirebaseStorage.instance.ref().child('unidad_files');
      final uploadTask = storageRef.child('${DateTime.now()}.pdf').putFile(file);
      final snapshot = await uploadTask;
      final fileUrl = await snapshot.ref.getDownloadURL();
      return fileUrl;
    } else {
      throw Exception('El archivo seleccionado no es un PDF');
    }
  } catch (e) {
    throw Exception('Error al cargar el archivo: ${e.toString()}');
  }
}


  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _tipo = null;
      _pdfFile = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Unidad de estudio',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Unidad',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: gColorTheme1_900),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre de la unidad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: gColorTheme1_900),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de Unidad',
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: gColorTheme1_900),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'biologia',
                    child: Text(
                      'Biología',
                      style: TextStyle(
                        fontWeight: FontWeight.normal, // Texto sin negrita
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'quimica',
                    child: Text(
                      'Química',
                      style: TextStyle(
                        fontWeight: FontWeight.normal, // Texto sin negrita
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'fisica',
                    child: Text(
                      'Física',
                      style: TextStyle(
                        fontWeight: FontWeight.normal, // Texto sin negrita
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona el tipo de unidad';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _tipo = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _pdfFile != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, size: 50.0),
                            Text(
                              'Archivo PDF Seleccionado',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        )
                      : Icon(Icons.archive, size: 50.0),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_pdfFile != null) {
                      final name = _nameController.text;
                      final description = _descriptionController.text;
                      final pdfUrl = await _uploadFile(_pdfFile!);
                      final tipo = _tipo.toString();
                      final idUsuario = usuarioController.usuario.value?.idUsuario;
                      
                      final unidadData = {
                        'idUnidad' : 0,
                        'idUsuario': idUsuario,
                        'nombre': name,
                        'descripcion': description,
                        'tipo': tipo,
                        'ruta': pdfUrl,
                        'eliminado' : false
                      };
                      controllerUnidad.registrarUnidad(unidadData);
                      Get.snackbar(
                          'Proceso exitoso',
                          'La unidad se registro correctamente',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: gColorTheme1_900,
                          colorText: Colors.white,
                        );
                      _resetForm();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, selecciona un archivo PDF'),
                          backgroundColor: Color.fromARGB(255, 152, 29, 29),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: gColorTheme1_1,                      
                  backgroundColor: gColorTheme1_700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Agregar Unidad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
