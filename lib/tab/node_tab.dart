import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/dto/link_item.dart';
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
    Map<String, List<LinkItem>> allNodeList =
        AppViewModel.of(context).allNodeList;
    if (allNodeList == null) {
      return new Center(child: new Text("暂无数据，请刷新"));
    }
    List<Widget> cardList = new List();
    allNodeList.forEach((key, value) {
      cardList.add(createCard(key, value));
    });
    cardList.add(new SizedBox(
      height: 40.0,
    ));
    return new Container(
      color: Config.backgroundColor,
      child: ListView(
        children: cardList,
      ),
    );
  }

  Card createCard(String name, List<LinkItem> linkList) {
    return Card(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Container(
        color: Colors.white70,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new Container(
                  child: new Center(
                    child:
                        new Text(name, style: TextStyle(color: Colors.white)),
                  ),
                  color: Config.panelHeaderColor,
                  height: 36.0,
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: linkList.map((linkItem) {
                  return new Chip(
                      label: new Text(
                    linkItem.name,
                  ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
