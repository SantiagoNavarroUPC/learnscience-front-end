import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controllerPersona.dart';
import 'package:flutter_application/controllers/controllerUsuario.dart';
import 'package:flutter_application/models/Persona.dart';
import 'package:get/get.dart';

class ListaPersonasScreen extends StatelessWidget {
  final PersonaController personaController = Get.put(PersonaController());

  @override
  Widget build(BuildContext context) {
    // Cargar personas cuando se inicia la pantalla
    personaController.obtenerPersonas();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Usuarios Activos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              final UsuarioController usuarioController =
                  Get.put(UsuarioController());
              final usuario = usuarioController.usuario.value!;
              if (usuario.tipo == 'profesor') {
                Navigator.pushReplacementNamed(context, "/menu_profesor");
              } else if (usuario.tipo == 'estudiante') {
                Navigator.pushReplacementNamed(context, "/menu_estudiante");
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: -150,
                left: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_700.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                right: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_400.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Obx(() {
                final personas = personaController.personas;
                return RefreshIndicator(
                  onRefresh: () async {
                    await personaController.obtenerPersonas();
                  },
                  child: personas.isEmpty
                      ? const Center(child: Text(''))
                      : ListView.builder(
                          itemCount: personas.length,
                          itemBuilder: (context, index) {
                            final persona = personas[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: gColorTheme1_800,
                                child: Text(
                                  '${persona.nombre[0]}${persona.apellido[0]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title:
                                  Text('${persona.nombre} ${persona.apellido}'),
                              subtitle: Text('Cédula: ${persona.cedula}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: gColorTheme1_800),
                                    onPressed: () {
                                      // Acción para editar la persona
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: gColorTheme1_800),
                                    onPressed: () async {},
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showPersonDetails(context, persona);
                              },
                            );
                          },
                        ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _showPersonDetails(BuildContext context, PersonaModel persona) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles de la Persona',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 16),
              Text('Cédula: ${persona.cedula}'),
              Text('Nombre: ${persona.nombre}'),
              Text('Apellido: ${persona.apellido}'),
              Text('Edad: ${persona.edad}'),
              Text('Teléfono: ${persona.telefono}'),
              Text('Dirección: ${persona.direccion}'),
              Text('Activo: ${persona.eliminado == true ? 'No' : 'Sí'}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el BottomSheet
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
