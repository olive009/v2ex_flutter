import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainViewState();
  }
}

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Container();
  }
}
