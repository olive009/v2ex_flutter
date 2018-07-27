import 'package:flutter/material.dart';
import 'package:v2ex_flutter/dto/menu.dart';

class RouteBuilder {
  static Widget getPageByMenu(Menu menu) {
    switch (menu.name) {
      default:
        return new Center(
          child: new Text("please implement the corespond page."),
        );
    }
  }
}
