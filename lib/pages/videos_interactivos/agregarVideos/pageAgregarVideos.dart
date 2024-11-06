import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controllerUsuario.dart';
import 'package:flutter_application/controllers/controllerVideo.dart';
import 'package:get/get.dart';
import 'dart:convert';

class VideoAdd extends StatefulWidget {
  static String routeName = "/add_video";

  @override
  _VideoAddState createState() => _VideoAddState();
}

class _VideoAddState extends State<VideoAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String? _tipo;

  VideoController controllerVideo = Get.find<VideoController>();
  UsuarioController usuarioController = Get.find<UsuarioController>();

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _urlController.clear();
      _tipo = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Video de estudio',
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
                  labelText: 'Nombre del Video',
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
                    return 'Por favor, ingresa el nombre del video';
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
                  labelText: 'Tipo de Video',
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'quimica',
                    child: Text(
                      'Química',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'fisica',
                    child: Text(
                      'Física',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona el tipo de video';
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
              TextFormField(
                controller: _urlController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  labelText: 'URL del Video (YouTube)',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: gColorTheme1_900),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, pega la URL del video';
                  } else if (!value.contains('youtube.com') && !value.contains('youtu.be')) {
                    return 'La URL debe ser de YouTube';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final description = _descriptionController.text;
                    final videoUrl = _urlController.text;
                    final tipo = _tipo.toString();
                    final idUsuario = usuarioController.usuario.value?.idUsuario;
                    
                    final videoData = {
                      'idVideo': 0,
                      'idUsuario': idUsuario,
                      'nombre': name,
                      'descripcion': description,
                      'tipo': tipo,
                      'ruta': videoUrl,
                      'eliminado': false
                    };

                    print(jsonEncode(videoData));
                    controllerVideo.registrarVideo(videoData);
                    Get.snackbar(
                      'Proceso exitoso',
                      'El video se registró correctamente',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: gColorTheme1_900,
                      colorText: Colors.white,
                    );
                    _resetForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: gColorTheme1_1,                      
                  backgroundColor: gColorTheme1_700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Agregar Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
