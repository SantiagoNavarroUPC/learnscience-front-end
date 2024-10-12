import 'package:flutter/material.dart';
import 'package:flutter_application/pages/onboarding/components/onboarding_view.dart';
import 'package:flutter_application/size_config.dart';
import '../../../components/default_button_secundary.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, dynamic>> onboardingData = [
  {
    "text": 
        "¡Prepárate para aprender y descubrir \nlos secretos de la biología! Explora \nel fascinante mundo de los seres vivos.",
    "image": "assets/images/image1.png"
  },
  {
    "text":
        "Sumérgete en el apasionante \nmundo de la química. ¡Aprende \ncon experimentos sorprendentes!",
    "image": "assets/images/image2.png"
  },
  {
    "text":
        "Descubre las maravillas de la física \nmientras exploras los principios que \ngobiernan el universo. ¡Una experiencia inolvidable!",
    "image": "assets/images/image3.png"
  }
];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: onboardingData[index]['image'],
                  text: onboardingData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(),
                    DefaultButtonSecundary(
                      text: "Continuar",
                      press: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: gAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? gColorTheme1_500
            : gColorTheme1_1,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
