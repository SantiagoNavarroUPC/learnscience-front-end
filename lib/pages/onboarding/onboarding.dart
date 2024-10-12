import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/pages/onboarding/components/body.dart';
import '../../../size_config.dart';

class Onboarding extends StatelessWidget {

  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
      backgroundColor: gColorTheme1_1,
    );
  }
}
