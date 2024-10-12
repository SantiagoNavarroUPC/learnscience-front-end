import 'package:flutter/material.dart';
import 'package:flutter_application/size_config.dart';

const gBackgroundColor = gColorTheme1_700;
const gBackgroundColorSecundary= Colors.white;
const gTextColor = Color(0xFF262626);
const gButtonColor = Colors.white;
const gButtonTextColor = Color(0xFF262626);
const gButtonColorSecundary = Color(0xFF009688);
const gPrimaryLightColor = Color.fromARGB(255, 252, 206, 236);
const gColorBanner1 = Color(0xFF388E3C);
const gColorBanner2 = Color(0xFF1976D2);
const gColorBanner3 = Color(0xFFE53935);
const gColorTheme1_1 = Colors.white;
const gColorTheme1_100 = Color(0xFFB2DFDB);
const gColorTheme1_200 = Color(0xFF80CBC4);
const gColorTheme1_300 = Color(0xFF4DB6AC);
const gColorTheme1_400 = Color(0xFF26A69A);
const gColorTheme1_500 = Color(0xFF009688);
const gColorTheme1_600 = Color(0xFF00897B);
const gColorTheme1_700 = Color(0xFF00796B);
const gColorTheme1_800 = Color(0xFF00695C);
const gColorTheme1_900 = Color(0xFF004D40);
const gColorTheme_Error = Color(0xFFE53935);
const gColorTheme_Inactive = Color(0xFF616161);


const gPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const gSecondaryColor = Color(0xFF979797);
// const gTextColor = Color(0xFF757575);

const gAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String gEmailNullError = "Por favor ingresar su correo electrónico";
const String gInvalidEmailError = "Por favor ingresar un correo electrónico válido";
const String gPassNullError = "Por favor ingresar su contraseña";
const String gShortPassError = "La contraseña es muy corta";
const String gMatchPassError = "Las contraseñas no coinciden";
const String gNamelNullError = "Por favor ingresar su nombre";
const String gPhoneNumberNullError = "Por favor ingresar su número de teléfono";
const String gAddressNullError = "Por favor ingresar su dirección";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: gTextColor),
  );
}
