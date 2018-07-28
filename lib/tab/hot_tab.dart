import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/dto/topic.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class HotTab extends BaseTab {
  HotTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _HotTabState();
  }
}

class _HotTabState extends State<HotTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: new Container(
        color: Config.backgroundColor,
        child: Column(
          children: <Widget>[
            createHotTopic(AppViewModel.of(context)),
            createHotNodeCard(AppViewModel.of(context)),
            createLatestNodeCard(AppViewModel.of(context)),
            new SizedBox(
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }

  Card createHotTopic(AppModel appModel) {
    return Card(
      color: Config.backgroundColor,
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
                    child: new Text(Config.LABEL_TODAY_HOT_TOPIC,
                        style: TextStyle(color: Colors.white)),
                  ),
                  color: Config.panelHeaderColor,
                  height: 36.0,
                ))
              ],
            ),
            Column(
                children: appModel.hotTopicList.map((topic) {
              return createHotTopicCard(topic);
            }).toList()
                  ..add(new SizedBox(
                    height: 8.0,
                  ))),
          ],
        ),
      ),
    );
  }

  Widget createHotTopicCard(Topic topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: InkWell(
        onTap: () async {
          String url = Config.root_url + topic.link;
          if (await canLaunch(url)) {
            await launch(url, forceWebView: true);
          } else {
            throw 'Could not launch $Config.login_url';
          }
        },
        child: Card(
          margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white70,
            child: new Row(
              children: <Widget>[
                new Card(
                    elevation: 0.0,
                    margin: EdgeInsets.all(0.0),
                    child: new Image.network(
                      "https:" + topic.avatar,
                      width: Config.avatarSize,
                      height: Config.avatarSize,
                      fit: BoxFit.fill,
                    ),
                  ),
                new Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          topic.itemTitle ?? "",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ]),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createHotNodeCard(AppModel appModel) {
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
                    child: new Text(Config.LABEL_HOT_NODE,
                        style: TextStyle(color: Colors.white)),
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
                children: appModel.hotNodeList.map((linkItem) {
                  return InkWell(
                    onTap: () async {
                      String url = Config.root_url + linkItem.href;
                      if (await canLaunch(url)) {
                        await launch(url, forceWebView: true);
                      } else {
                        throw 'Could not launch $Config.login_url';
                      }
                    },
                    child: new Chip(
                        label: new Text(
                      linkItem.name,
                    )),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createLatestNodeCard(AppModel appModel) {
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
                    child: new Text(Config.LABEL_LATEST_NODE,
                        style: TextStyle(color: Colors.white)),
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
                children: appModel.latestNodeList.map((linkItem) {
                  return InkWell(
                    onTap: () async {
                      String url = Config.root_url + linkItem.href;
                      if (await canLaunch(url)) {
                        await launch(url, forceWebView: true);
                      } else {
                        throw 'Could not launch $Config.login_url';
                      }
                    },
                    child: new Chip(
                        label: new Text(
                      linkItem.name,
                    )),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
