import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:get/get.dart';
import '../../controllers/controllerUsuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UsuarioController usuarioController = Get.put(UsuarioController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Hacer el AppBar transparente
        elevation: 0, // Eliminar la sombra del AppBar
      ),
      body: Stack(
        children: [
          // Capa de fondo con formas
          Positioned(
            top: -100,
            left: -150,
            child: Container(
              width: 280,
              height: 300,
              decoration: BoxDecoration(
                color: gColorTheme1_700.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: 280,
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: gColorTheme1_700.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Contenido principal
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey, // Asignamos la clave del formulario
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    // Imagen o logo
                    Container(
                      width: 200,
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400), // Limita el ancho máximo
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título "Iniciar Sesión"
                          const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingrese su dirección de correo electrónico y contraseña para acceder a la cuenta.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Campo de correo electrónico
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Correo Electrónico',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.teal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el correo electrónico';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Por favor ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Campo de contraseña
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.teal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Botones de inicio de sesión y registro
                          Obx(() {
                            if (usuarioController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: gBackgroundColorSecundary,
                                            backgroundColor: gColorTheme1_900,
                                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                                            textStyle: const TextStyle(fontSize: 18, fontFamily: 'Inter'),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                            final email = emailController.text;
                                            final password = passwordController.text;
                                            await usuarioController.loginUsuario(email, password);
                                            if (usuarioController.usuario.value != null) {
                                              final usuario = usuarioController.usuario.value!;
                                              if (usuario.tipo == 'profesor') {
                                                Get.toNamed("/menu_profesor");
                                              } else if (usuario.tipo == 'estudiante') {
                                                 Get.toNamed('/menu_estudiante');
                                              } else {
                                                Get.snackbar(
                                                  'Error',
                                                  'Tipo de usuario desconocido',
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: gColorThemeError,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                usuarioController.errorMessage.value,
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: gColorThemeError,
                                                colorText: Colors.white,
                                              );
                                            }
                                            emailController.clear();
                                            passwordController.clear();
                                          }

                                          },
                                          child: const Text('Iniciar Sesión'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: gColorTheme1_900,
                                            backgroundColor: gBackgroundColorSecundary,
                                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                                            textStyle: const TextStyle(fontSize: 18),
                                            side: const BorderSide(color: gColorTheme1_900, width: 2),
                                          ),
                                          onPressed: () {
                                            emailController.clear();
                                            passwordController.clear();
                                            Get.toNamed('/registrarse');
                                          },
                                          child: const Text('Registrarse'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}