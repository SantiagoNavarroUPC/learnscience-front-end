class UnidadModel {
  int? idUnidad;
  int? idUsuario;
  String? nombre;
  String? descripcion;
  String? tipo;
  String? ruta;
  bool? eliminado;

  UnidadModel({this.idUnidad, this.idUsuario, this.nombre, this.descripcion, this.tipo, this.ruta,this.eliminado});


  factory UnidadModel.fromJson(Map<String, dynamic> json) {
    return UnidadModel(
      idUnidad: json['idUnidad'],
      idUsuario: json['idUsuario'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
      ruta: json['ruta'],
      eliminado: json['eliminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idUnidad": idUnidad,
      "idUsuario": idUsuario,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo,
      'ruta': ruta,
      "eliminado": eliminado,
    };
  }
}
