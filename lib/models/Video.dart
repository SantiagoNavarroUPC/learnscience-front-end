class VideoModel {
  int? idVideo;
  int? idUsuario;
  String? nombre;
  String? descripcion;
  String? tipo;
  String? ruta;
  bool? eliminado;

  VideoModel({this.idVideo, this.idUsuario, this.nombre, this.descripcion, this.tipo, this.ruta,this.eliminado});


  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      idVideo: json['idVideo'],
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
      "idVideo": idVideo,
      "idUsuario": idUsuario,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo,
      'ruta': ruta,
      "eliminado": eliminado,
    };
  }
}
