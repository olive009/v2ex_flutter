import 'package:flutter/material.dart';

class ColorUtil {
  static Color hexToColor(String code) {
    Color color = Colors.red;
    if (code != null && code.length == 7) {
      try {
        color =
            new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
      } catch (e) {
        print(e.toString());
      }
    }
    return color;
  }
}
