import 'package:flutter/material.dart';
import '../../../../size_config.dart';
import '../../login/page_login.dart';
import 'package:animate_do/animate_do.dart';


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FadeIn(duration: const Duration(seconds: 2), 
            child: const LoginScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(seconds: 1), // Ajusta la duración de la transición
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            const Spacer(flex: 2),
            Align(
              child: Image.asset(
                "assets/images/logo1.png",
                height: getProportionateScreenHeight(400),
                width: getProportionateScreenWidth(400),
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: const Column(
                  children: <Widget>[
                    Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
