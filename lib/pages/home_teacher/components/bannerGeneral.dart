import 'package:flutter/material.dart';


class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;  // Nuevo parámetro de color

  const MenuTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,  // Requerido
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,  // Usamos el color pasado como argumento
      elevation: 4,
      child: InkWell(
        onTap: () {
          switch (title) {
          case 'Unidades':
            Navigator.pushNamed(context, '/unidades');
            break;
          case 'Videos\nInteractivos':
            Navigator.pushNamed(context, '/videos');
            break;
          case 'Cuestionarios':
            Navigator.pushNamed(context, '/cuestionarios');
            break;
          case 'Videojuegos':
            Navigator.pushNamed(context, '/videojuegos');
            break;
          case 'Usuarios':
            Navigator.pushNamed(context, '/usuarios');
            break;
          case 'Configuración':
            Navigator.pushNamed(context, '/configuracion');
            break;
          default:
            break;
        }
          
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.white), // Icono blanco por contraste
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Texto blanco
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
