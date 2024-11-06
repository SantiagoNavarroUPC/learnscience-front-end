import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../../../constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    this.text,
    this.image,
  });
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Image.asset(
          "assets/images/logo2.png",
          height: getProportionateScreenHeight(109),
          width: getProportionateScreenWidth(80),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: gTextColor,
          ),
        ),
        const Spacer(flex: 3),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(335),
          width: getProportionateScreenWidth(450),
        ),
      ],
    );
  }
}
