import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/enums.dart';
import 'package:flutter_application/pages/home/components/body.dart';
import 'package:get/get.dart';

import '../../components/coustom_bottom_nav_bar.dart';


class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Temario de asignaturas',
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
      body: const Body(), // Tu widget Body
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home), // Tu barra de navegación
    );
  }
void _cerrarSesion() {
    // Mostrar notificación con GetX
    Get.snackbar(
      'Hasta luego',
      'Vuelve pronto',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorTheme1_800,
      colorText: Colors.white,
    );

    // Salir de la aplicación después de un pequeño retraso para que la notificación sea visible
    Future.delayed(Duration(seconds: 1), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}