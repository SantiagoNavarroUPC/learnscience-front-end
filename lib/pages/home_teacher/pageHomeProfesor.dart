import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/enums.dart';
import 'package:flutter_application/pages/home_teacher/components/body.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeTeacher extends StatelessWidget {
  const HomeTeacher({super.key});

  void _cerrarSesion() {
    // Mostrar notificación con GetX
    Get.snackbar(
      'Hasta luego',
      'Vuelve pronto',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorTheme1_800,
      colorText: Colors.white,
    );
    Future.delayed(const Duration(seconds: 1), () {
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
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _cerrarSesion();
            },
          ),
        ],
      ),
      body: const Body(),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
