import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/controllers/controller_video.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/components/page_visualizacion_video.dart';
import 'package:get/get.dart';

class ListaVideosEstudiante extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController());
  final String area;

  ListaVideosEstudiante({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    UsuarioController usuarioController = Get.find<UsuarioController>();
    videoController.obtenerVideosPorTipoActivos(area: area);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Índice de Videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background Circles
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
                    color: gColorTheme1_600.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              Obx(() {
                if (videoController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (videoController.hasError.value) {
                  return const Center(child: Text('No se pudieron obtener los videos'));
                }

                if (videoController.videos.isEmpty) {
                  return const Center(child: Text('No hay videos disponibles para esta área'));
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
                    await videoController.obtenerVideosPorTipoActivos(area: area);
                  },
                  child: ListView.builder(
                    itemCount: videoController.videos.length,
                    itemBuilder: (context, index) {
                      final video = videoController.videos[index];
                      final bool isEliminado = video.eliminado ?? false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isEliminado ? gColorThemeInactive : getColorForArea(),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${video.nombre}'),
                        subtitle: Text('${video.descripcion}'),
                        trailing: (usuarioController.usuario.value?.tipo == 'profesor') 
                            ? DropdownButton<bool>(
                                icon: Icon(Icons.edit, color: isEliminado ? gColorThemeInactive : getColorForArea()),
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
                                        videoController.obtenerVideosPorTipoActivos(area: area);
                                      }
                                    });
                                  }
                                },
                                items: const [
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
                              backgroundColor: gColorThemeInactive,
                              colorText: Colors.white,
                            );
                          } else {
                            final video = videoController.videos[index];
                            final videoUrl = video.ruta!.split('?v=').last;
                            final idvideos = video.idVideo;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InteractiveVideoPage(videoUrl: videoUrl, idVideo: idvideos),
                              ),
                            );
                          }
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
}

