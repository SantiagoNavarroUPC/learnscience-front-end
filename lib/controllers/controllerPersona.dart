import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/Persona.dart';
import '../requests/requestPersona.dart';


class PersonaController extends GetxController {
  final PersonaService _personaService = PersonaService();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Método para registrar o actualizar una persona
  Future<bool> guardarPersona(PersonaModel persona) async {
    isLoading.value = true;
    try {
      if (persona.idUsuario == null) {
        errorMessage.value = 'ID de usuario no disponible';
        return false;
      }

      int idUsuario = persona.idUsuario!;

      PersonaModel? personaExistente = await obtenerPersonaPorIdUsuario(idUsuario);

      bool success;
      if (personaExistente != null) {
        success = await _personaService.actualizarPersona(persona);
      } else {
        success = await _personaService.registrarPersona(persona);
      }

      if (success) {
        errorMessage.value = '';
        return true;
      } else {
        errorMessage.value = 'Error al guardar persona';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<PersonaModel?> obtenerPersonaPorIdUsuario(int idUsuario) async {
  try {
    // Llama al servicio para obtener la persona por ID de usuario
    final response = await _personaService.obtenerPersonaPorIdUsuario(idUsuario);
    print('Respuesta JSON obtenida: $response');

    if (response != null) {
      // Decodifica el JSON
      final data = response['response']; // Extrae el objeto PersonaModel del JSON
      if (data != null) {
        // Crea una instancia de PersonaModel
        PersonaModel persona = PersonaModel.fromJson(data);
        return persona;
      } else {
        print('No se encontró la persona con el ID de usuario: $idUsuario');
        return null;
      }
    } else {
      print('No se encontró la respuesta del servidor');
      return null;
    }
  } catch (e) {
    print('Error al obtener la persona: $e');
    return null;
  }
}

  var personas = <PersonaModel>[].obs;

  Future<void> obtenerPersonas() async {
    try {
      var listaPersonas = await PersonaService().obtenerPersonas();
      personas.value = listaPersonas;
    } catch (e) {
      Get.snackbar(
            'Error',
            'Error al encontrar personas',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gColorTheme_Error,
            colorText: Colors.white,
          );
    }
  }
}




