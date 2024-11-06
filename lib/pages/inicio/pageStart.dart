import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import '../../size_config.dart';
import 'components/body.dart';


class StartApp extends StatelessWidget {

  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
      backgroundColor: gColorTheme1_500,
    );
  }
}
