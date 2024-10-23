import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/enums.dart';
import 'package:flutter_application/pages/home_teacher/components/bannerGeneral.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeTeacher extends StatelessWidget {
  const HomeTeacher({Key? key}) : super(key: key);

  void _cerrarSesion() {
    // Mostrar notificación con GetX
    Get.snackbar(
      'Hasta luego',
      'Vuelve pronto',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorTheme1_800,
      colorText: Colors.white,
    );
    Future.delayed(Duration(seconds: 1), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu Principal',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Esto centra el título
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _cerrarSesion();
            },
          ),
        ],
      ),
      body: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(18),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        MenuTile(icon: Icons.book, title: 'Unidades', color: Colors.blue), 
        MenuTile(icon: Icons.video_library, title: 'Videos\nInteractivos', color: Colors.red),
        MenuTile(icon: Icons.quiz, title: 'Cuestionarios', color: Colors.pink), 
        MenuTile(icon: Icons.games, title: 'Videojuegos', color: Colors.green), 
        MenuTile(icon: Icons.people, title: 'Usuarios', color: Colors.deepPurple),
        MenuTile(icon: Icons.settings, title: 'Configuración', color: Colors.brown), 
      ],
    ),
    bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}