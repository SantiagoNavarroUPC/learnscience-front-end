import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controllerUsuario.dart';
import 'package:flutter_application/controllers/controllerVideo.dart';
import 'package:flutter_application/pages/videos_interactivos/listaVideos/components/pageVisualizacionVideo.dart';
import 'package:get/get.dart';


class ListaVideosEstudiante extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController());
  final String area;

  ListaVideosEstudiante({required this.area});

  @override
  Widget build(BuildContext context) {
    UsuarioController usuarioController = Get.find<UsuarioController>();
    videoController.listarVideosActivos();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Índice de Videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (videoController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (videoController.hasError.value) {
          return Center(child: Text('No se pudieron obtener los videos'));
        }

        if (videoController.videos.isEmpty) {
          return Center(child: Text('No hay videos disponibles para esta área'));
        }
        
        Color getColorForArea() {
          switch (area.toLowerCase()) {
            case 'biologia':
              return gColorBanner1;
            case 'quimica':
              return gColorBanner2;
            case 'fisica':
              return gColorBanner3;
            default:
              return Colors.grey;
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            await videoController.listarVideosActivos();
          },
          child: ListView.builder(
            itemCount: videoController.videos.length,
            itemBuilder: (context, index) {
              final video = videoController.videos[index];
              final bool isEliminado = video.eliminado ?? false;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isEliminado ? gColorTheme_Inactive : getColorForArea(),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${video.nombre}'),
                subtitle: Text('${video.descripcion}'),
                trailing: (usuarioController.usuario.value?.tipo == 'profesor') 
                    ? DropdownButton<bool>(
                        icon: Icon(Icons.edit, color: isEliminado ? gColorTheme_Inactive : getColorForArea()),
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            video.eliminado = newValue;
                            videoController.actualizarVideo(video).then((success) {
                              if (!success) {
                                Get.snackbar(
                                  'Error',
                                  'No se pudo actualizar el video',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                videoController.listarVideosActivos();
                              }
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('Activo', style: TextStyle(color: Colors.black)),
                          ),
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Inactivo', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      )
                    : null,
                onTap: () {
                  if (isEliminado) {
                    Get.snackbar(
                      'Video Inactivo',
                      'Este video no está activo.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: gColorTheme_Inactive,
                      colorText: Colors.white,
                    );
                  } else {
                    final video = videoController.videos[index];
                    final videoUrl = video.ruta!.split('?v=').last;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InteractiveVideoPage(videoUrl: videoUrl),
                  ),
                );
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}
