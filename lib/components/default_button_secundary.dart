import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButtonSecundary extends StatelessWidget {
  const DefaultButtonSecundary({
    super.key,
    this.text,
    this.press,
  });
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: gBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: gButtonColorSecundary,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
              color: gButtonColor,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenWidth(20)),
        ),
      ),
    );
  }
}
