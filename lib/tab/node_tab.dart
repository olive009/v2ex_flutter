import 'package:flutter/material.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';

class NodeTab extends BaseTab {
  NodeTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _NodeTabState();
  }
}

class _NodeTabState extends State<NodeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Config.backgroundColor,
        child: new Center(child: new Text("节点")));
  }
}
