import 'package:flutter/material.dart';

class BaseTab extends StatefulWidget {
  String tabName;

  @override
  State<StatefulWidget> createState() {
    throw Exception("children must override this method!!!");
  }
}
