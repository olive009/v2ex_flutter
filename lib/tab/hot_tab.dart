import 'package:flutter/material.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';

class HotTab extends BaseTab {
  HotTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _InfoTabState();
  }
}

class _InfoTabState extends State<HotTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Config.backgroundColor,
        child: new Center(child: new Text("热门")));
  }
}
