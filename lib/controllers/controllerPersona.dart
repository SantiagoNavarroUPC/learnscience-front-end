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
    final response = await _personaService.obtenerPersonaPorIdUsuario(idUsuario);
    if (response != null) {
      final data = response['response'];
      if (data != null) {
        PersonaModel persona = PersonaModel.fromJson(data);
        return persona;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
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




