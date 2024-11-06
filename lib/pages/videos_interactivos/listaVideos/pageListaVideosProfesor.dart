import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controllerVideo.dart';
import 'package:flutter_application/pages/videos_interactivos/listaVideos/components/pageVisualizacionVideo.dart';
import 'package:get/get.dart';

class ListaVideosProfesor extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController());  // Hacer que el área seleccionada sea reactiva
  final RxString areaSeleccionada = 'biologia'.obs;

  @override
  Widget build(BuildContext context) {
    videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/añadirVideo");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Siempre muestra el DropdownButton
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Obx(() => DropdownButton<String>(
                    value: areaSeleccionada.value,
                    onChanged: (String? nuevaArea) {
                      if (nuevaArea != null) {
                        areaSeleccionada.value = nuevaArea;
                        videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                      }
                    },
                    items: <String>['biologia', 'quimica', 'fisica'].map((String area) {
                      return DropdownMenuItem<String>(
                        value: area,
                        child: Text(
                          area.capitalize!,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                    iconSize: 30,
                  )),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (videoController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (videoController.hasError.value) {
                return Center(child: Text('No se pudieron obtener los videos'));
              }

              if (videoController.videos.isEmpty) {
                return Center(child: Text('No hay videos disponibles para esta área'));
              }

              Color getColorForArea(String area) {
                switch (area.toLowerCase()) {
                  case 'biologia':
                    return gColorBanner1;
                  case 'quimica':
                    return gColorBanner2;
                  case 'fisica':
                    return gColorBanner3;
                  default:
                    return gColorTheme1_600;
                }
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                },
                child: ListView.builder(
                  itemCount: videoController.videos.length,
                  itemBuilder: (context, index) {
                    final video = videoController.videos[index];
                    final videoUrl = video.ruta!.split('?v=').last;
                    final bool isEliminado = video.eliminado ?? false;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getColorForArea(areaSeleccionada.value),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(video.nombre ?? ''),
                      subtitle: Text(video.descripcion ?? ''),
                      trailing: Switch(
                        value: isEliminado,
                        onChanged: (newValue) {
                          video.eliminado = newValue;
                          videoController.actualizarVideo(video).then((success) {
                            if (!success) {
                              Get.snackbar(
                                'Error',
                                'No se pudo actualizar el estado del video',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else {
                              videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                            }
                          });
                        },
                        activeTrackColor: Colors.red,
                        inactiveThumbColor: Colors.green,
                      ),
                      onTap: () {
                        if (isEliminado) {
                          Get.snackbar(
                            'Video Inactivo',
                            'Este video no está activo.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey,
                            colorText: Colors.white,
                          );
                        } else {
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
          ),
        ],
      ),
    );
  }
}
