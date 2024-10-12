class PersonaModel {
  int? idPersona;
  int? idUsuario;
  String cedula;
  String nombre;
  String apellido;
  int edad;
  String telefono;
  String direccion;
  bool? eliminado;

  PersonaModel({
    this.idPersona,
    this.idUsuario,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.telefono,
    required this.direccion,
    this.eliminado,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      idPersona: json['idPersona'],
      idUsuario: json['idUsuario'],
      cedula: json['cedula'].toString(),
      nombre: json['nombre'],
      apellido: json['apellido'],
      edad: json['edad'],
      telefono: json['telefono'].toString(),
      direccion: json['direccion'],
      eliminado: json['eliminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idPersona": idPersona,
      "idUsuario": idUsuario,
      "cedula": cedula,
      "nombre": nombre,
      "apellido": apellido,
      "edad": edad,
      "telefono": telefono,
      "direccion": direccion,
      "eliminado": eliminado,
    };
  }
}

