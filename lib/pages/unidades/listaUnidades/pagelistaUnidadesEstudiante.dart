import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controllerUnidad.dart';
import 'package:flutter_application/controllers/controllerUsuario.dart';
import 'package:flutter_application/pages/unidades/listaUnidades/components/vistaPDF.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ListaUnidadesEstudiante extends StatelessWidget {
  final UnidadController unidadController = Get.put(UnidadController());
  final String area;

  ListaUnidadesEstudiante({required this.area});

  @override
  Widget build(BuildContext context) {
    UsuarioController usuarioController = Get.find<UsuarioController>();
    unidadController.obtenerUnidadesPorTipo(area: area);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indice de Unidades',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (unidadController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (unidadController.hasError.value) {
          return Center(child: Text('No se pudieron obtener las unidades'));
        }

        if (unidadController.unidades.isEmpty) {
          return Center(child: Text('No hay unidades disponibles para esta área'));
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
              return Colors.grey; // Color por defecto si no coincide con ninguna área
          }
        }
        return RefreshIndicator(
          onRefresh: () async {
            await unidadController.obtenerUnidadesPorTipo(area: area);
          },
          child: ListView.builder(
            itemCount: unidadController.unidades.length,
            itemBuilder: (context, index) {
              final unidad = unidadController.unidades[index];
              final bool isEliminado = unidad.eliminado ?? false;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isEliminado ? gColorThemeInactive : getColorForArea(),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${unidad.nombre}'),
                subtitle: Text('${unidad.descripcion}'),
                trailing: (usuarioController.usuario.value?.tipo == 'profesor') 
                    ? DropdownButton<bool>(
                        icon: Icon(Icons.edit, color: isEliminado ? gColorThemeInactive : getColorForArea()),
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            unidad.eliminado = newValue;
                            unidadController.actualizarUnidad(unidad).then((success) {
                              if (!success) {
                                Get.snackbar(
                                  'Error',
                                  'No se pudo actualizar la unidad',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                unidadController.obtenerUnidadesPorTipo(area: area);
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
                      'Unidad Inactiva',
                      'Esta unidad no está activa.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: gColorThemeInactive,
                      colorText: Colors.white,
                    );
                  } else {
                    _downloadPdf(unidad.ruta!, context);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }

  void _downloadPdf(String pdfUrl, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/my_pdf.pdf';

      Dio dio = Dio();
      await dio.download(pdfUrl, savePath);
      print('Descarga completada: $savePath');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewPage(filePath: savePath),
        ),
      );
    } catch (e) {
      print('Error al descargar el PDF: $e');
    }
  }
}
