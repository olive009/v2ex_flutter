import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/component/rx_widgets.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/dto/topic.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';

class IndexTab extends BaseTab {
  IndexTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _IndexTabState();
  }
}

class _IndexTabState extends State<IndexTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AppModel appModel;
  String currentTabName;

  @override
  Widget build(BuildContext context) {
    appModel = AppViewModel.of(context);
    appModel.getIndexDataCommand.execute(appModel);
    return new Container(
      child: getBodyWidget(context),
      color: Config.backgroundColor,
    );
  }

  Widget getBodyWidget(BuildContext context) {
    return RxCommandBuilder(
      commandResults: AppViewModel.of(context).getIndexDataCommand,
      busyBuilder: (context) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
      dataBuilder: (context, appModel) {
        return createTabs(appModel);
      },
      placeHolderBuilder: (context) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
    );
  }

  Widget createTabs(AppModel appModel) {
    List<Tab> tabs = appModel.tabList.map((linkItem) {
      return new Tab(
        child: new Text(linkItem.name),
      );
    }).toList();
    if (_tabController == null) {
      _tabController = new TabController(vsync: this, length: tabs.length);
      _tabController.addListener(_handleTabSelection);
    }
    TabBar tabBar = new TabBar(
      tabs: tabs,
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.pink,
      labelColor: Colors.pink,
      unselectedLabelColor: Colors.white,
    );

    List<Widget> chips = appModel.currentNodeList.map((linkItem) {
      return Padding(
          padding: EdgeInsets.only(left: 10.0, top: 6.0, bottom: 6.0),
          child: new Chip(label: new Text(linkItem.name)));
    }).toList();

    return new Column(
      children: <Widget>[
        new Container(
          child: tabBar,
          color: Colors.blueGrey,
        ),
        new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            children: chips,
          ),
        ),
        Expanded(
          child: ListView(
            children: appModel.topicList.map((topic) {
              return createCard(topic);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget createCard(Topic topic) {
    return Card(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: new Text(topic.replyText),
                    ),
                  ]),
            )),
            new Center(
              child: new Container(
                child: new Text(topic.replyCount ?? "0"),
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    String changingTab = appModel.tabList[_tabController.index].name;
    if (currentTabName != changingTab) {
      currentTabName = changingTab;
      appModel.currentUrl = appModel.tabList[_tabController.index].href;
      appModel.getIndexDataCommand.execute(appModel);
    }
  }
}
