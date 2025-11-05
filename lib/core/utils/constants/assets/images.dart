
import 'package:flutter/cupertino.dart';

class AppImages{

  static final String BG = "assets/images/bg.png";
  static final String BLUR = "assets/images/blur.png";

  static final String EURO_CURRENCY = "assets/images/euro_currency.png";
  static final String UEA_CURRENCY = "assets/images/uea_currency.png";
  static final String USA_CURRENCY = "assets/images/usa_currency.png";

  static final String AMERCA_FLAG = "assets/images/amerca_flag.png";
  static final String EMARATE_FLAG = "assets/images/emarate_flag.png";
  static final String GERMAN_FLAG = "assets/images/german_flag.png";
  static final String INDIA_FLAG = "assets/images/india_flag.png";
  static final String ISPANYA_FLAG = "assets/images/ispanya_flag.png";
  static final String RUSSIAN_FLAG = "assets/images/russian_flag.png";

  static final String LOGO_BLACK = "assets/images/logo_black.png";
  static final String LOGO_WHITE = "assets/images/logo_white.png";

  static Widget image(
      {required String assetName, double? width, double? height}) {
    return Image.asset(
      assetName,
      width: width,
      height: height,
    );
  }

}