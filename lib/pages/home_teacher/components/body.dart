import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home_teacher/components/banner_general.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(18),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          MenuTile(
            title: 'Unidades', 
            imagePath: 'assets/images/banners/guias.png', // Ruta de la imagen
            color: Colors.blue
          ),
          MenuTile(
            title: 'Videos\nInteractivos', 
            imagePath: 'assets/images/banners/videos.png', // Ruta de la imagen
            color: Colors.red
          ),
          MenuTile(
            title: 'Cuestionarios', 
            imagePath: 'assets/images/banners/cuestionarios.png', // Ruta de la imagen
            color: Colors.pink
          ),
          MenuTile(
            title: 'Videojuegos', 
            imagePath: 'assets/images/banners/videojuegos.png', // Ruta de la imagen
            color: Colors.green
          ),
          MenuTile(
            title: 'Usuarios', 
            
            imagePath:'assets/images/banners/usuarios.png', // Ruta de la imagen
            color: Colors.deepPurple
          ),
          MenuTile(
            title: 'Configuración', 
            imagePath: 'assets/images/banners/ajustes.png', // Ruta de la imagen
            color: Colors.brown
          ),
        ],
      );
  }}