class UsuarioModel {
  int? idUsuario;
  String correo;
  String contrasena;
  String? tipo;
  bool? eliminado;

  UsuarioModel({
    this.idUsuario,
    required this.correo,
    required this.contrasena,
    this.tipo,
    this.eliminado
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json['idUsuario'],
      correo: json['correo'] ?? '',
      contrasena: json['contrasena'] ?? '',
      tipo: json['tipo'] ?? '',
      eliminado: json['eliminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contraseña': contrasena,
      'tipo':tipo
    };
  }
}
