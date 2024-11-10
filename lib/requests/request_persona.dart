import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/persona.dart';


class PersonaService {
  final String baseUrl = "http://apirestdatos00.somee.com/api/Persona";
  final box = GetStorage();

  Future<Map<String, dynamic>?> obtenerPersonaPorIdUsuario(int idUsuario) async {
    final response = await http.get(Uri.parse('$baseUrl/Obtener/$idUsuario'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> actualizarPersona(PersonaModel persona) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Editar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(persona.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> registrarPersona(PersonaModel persona) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Guardar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(persona.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<List<PersonaModel>> obtenerPersonas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Lista'), // Ajusta el endpoint según tu API
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> personasJson = data['response']; // Ajusta según la estructura de tu respuesta
        return personasJson.map((json) => PersonaModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener personas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de personas: $e');
    }
  }
}
