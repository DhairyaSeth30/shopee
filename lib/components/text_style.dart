import 'package:flutter/material.dart';

class AppTextStyle {
  static const headLineOne = TextStyle(
    color: Colors.black,
    fontSize: 25.0,
    fontWeight: FontWeight.w700,
  );
  static const smallTextOne = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static const smallTextTwo = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textStyleOne(
      Color color,
      double size,
      FontWeight fontWeight,
      ) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textStyleTwo(
      String fontFamily,
      Color color,
      double size,
      FontWeight fontWeight,
      ) {
    return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }
}

InputDecoration kinputBorderDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    labelStyle: const TextStyle(
      color: Color.fromRGBO(2, 6, 20, 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      const BorderSide(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}
