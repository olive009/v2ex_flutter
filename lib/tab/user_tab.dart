import 'package:flutter/material.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';

class UserTab extends BaseTab {
  UserTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _UserTabState();
  }
}

class _UserTabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Config.backgroundColor,
        child: new Center(child: new Text("我的")));
  }
}
