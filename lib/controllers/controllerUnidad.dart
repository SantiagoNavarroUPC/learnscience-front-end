import 'package:flutter/material.dart';
import 'package:flutter_application/models/Unidad.dart';
import 'package:flutter_application/requests/requestUnidad.dart';
import 'package:get/get.dart';

import '../constants.dart';

class UnidadController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs; 

  final UnidadRequest _unidadService = UnidadRequest(); // Asegúrate de tener tu servicio configurado

  Future<bool> registrarUnidad(Map<String, dynamic> unidadData) async {
    isLoading.value = true;
    try {
      final registrado = await _unidadService.registrarUnidad(unidadData);
      if (registrado) {
        errorMessage.value = 'Unidad registrada con éxito';
        return true;
      } else {
        errorMessage.value = 'Error al registrar unidad';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  var unidades = <UnidadModel>[].obs;
  Future<void> obtenerUnidades() async {
    try {
      isLoading.value = true;
      var listaUnidades = await UnidadRequest().obtenerUnidades();
      unidades.value = listaUnidades;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron obtener las unidades',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> obtenerUnidadesPorTipo({String? area}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      var listaUnidades = await UnidadRequest().obtenerUnidades();
      if (area != null) {
        listaUnidades = listaUnidades.where((unidad) => unidad.tipo == area).toList();
      }
      unidades.value = listaUnidades;
      if (unidades.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true; // Manejar errores
      Get.snackbar(
        'Error',
        'No se pudieron obtener las unidades',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> actualizarUnidad(UnidadModel unidad) async {
    try {
      isLoading.value = true; // Inicia la carga
      bool success = await UnidadRequest().actualizarUnidad(unidad);
      if (success) {
        Get.snackbar(
          'Éxito',
          'Unidad actualizada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo actualizar la unidad',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme_Error,
          colorText: Colors.white,
        );
      }
      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al intentar actualizar la unidad: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme_Error,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
}
