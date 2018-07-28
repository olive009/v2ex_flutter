import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/component/bottom_tab_item.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2ex_flutter/dto/link_item.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';
import 'package:v2ex_flutter/tab/hot_tab.dart';
import 'package:v2ex_flutter/tab/index_tab.dart';
import 'package:v2ex_flutter/tab/node_tab.dart';
import 'package:v2ex_flutter/tab/user_tab.dart';

class AppScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppScaffoldState();
  }
}

class _AppScaffoldState extends State<AppScaffold> {
  List<Widget> tabList;
  List<BaseTab> tabContainerList = new List<BaseTab>();
  IndexTab indexTab;
  NodeTab nodeTab;
  HotTab hotTab;
  UserTab userTab;
  StreamSubscription selectTabSubscription;

  @override
  void dispose() {
    selectTabSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    tabChangeHandler(Config.TAB_NAME_INDEX);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (selectTabSubscription == null) {
      selectTabSubscription = AppViewModel
          .of(context)
          .selectTabCommand
          .results
          .listen(tabChangeHandler);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Config.appName),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              _launchURL(Config.search_url);
            },
            iconSize: 32.0,
          )
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        elevation: 2.0,
        notchMargin: 6.0,
        shape: new CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildTabs(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          new FloatingActionButton(child: new Icon(Icons.add), onPressed: (){
            _launchURL(Config.login_url);
          }),
      drawer: new Drawer(
        child: ListView(
          children: _buildDrawerNavLink(context),
        ),
      ),
      body: new Center(child: _buildTabStack()),
    );
  }

  List<Widget> _buildDrawerNavLink(BuildContext context) {
    List<Widget> navList = new List();
    navList.add(new ListTile(
      title: Text("关于"),
      leading: Icon(Icons.home),
      onTap: () {
        _launchURL(Config.root_url +"/about");
      },
    ));
    navList.add(new ListTile(
      title: Text("FAQ"),
      leading: Icon(Icons.announcement),
      onTap: () {
        _launchURL(Config.root_url +"/faq");
      },
    ));
    navList.add(new ListTile(
      title: Text("API"),
      leading: Icon(Icons.font_download),
      onTap: () {
        _launchURL(Config.root_url +"/p/7v9TEc53");
      },
    ));
    navList.add(new ListTile(
      title: Text("我们的愿景"),
      leading: Icon(Icons.accessibility),
      onTap: () {
        _launchURL(Config.root_url +"/mission");
      },
    ));
    navList.add(new ListTile(
      title: Text("广告投放"),
      leading: Icon(Icons.monetization_on),
      onTap: () {
        _launchURL("/advertise");
      },
    ));
    navList.add(new ListTile(
      title: Text("鸣谢"),
      leading: Icon(Icons.record_voice_over),
      onTap: () {
        _launchURL(Config.root_url +"/advertise/2016.html");
      },
    ));
    navList.add(new ListTile(
      title: Text("实用小工具"),
      leading: Icon(Icons.settings),
      onTap: () {
        _launchURL(Config.root_url +"/tools");
      },
    ));
    return navList;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> _buildTabs(BuildContext context) {
    AppModel appModel = AppViewModel.of(context);
    //does not need to rebuild every time.
    if (tabList == null) {
      tabList = <Widget>[
        new BottomTabItem(
            iconData: Icons.home,
            name: Config.TAB_NAME_INDEX,
            appModel: appModel,
            isSelected: true),
        new BottomTabItem(
            iconData: Icons.message,
            name: Config.TAB_NAME_NODE,
            appModel: appModel),
        SizedBox(
          width: 32.0,
        ),
        new BottomTabItem(
            iconData: Icons.insert_chart,
            name: Config.TAB_NAME_HOT,
            appModel: appModel),
        new BottomTabItem(
            iconData: Icons.person,
            name: Config.TAB_NAME_USER,
            appModel: appModel),
      ];
    }
    return tabList;
  }

  Widget _buildTabStack() {
    //need to rebuild the stack.
    return new Stack(
      children: tabContainerList,
    );
  }

  tabChangeHandler(String tabName) {
    if (tabName == Config.TAB_NAME_INDEX && indexTab == null) {
      indexTab = new IndexTab(tabName);
      tabContainerList.add(indexTab);
    } else if (tabName == Config.TAB_NAME_NODE && nodeTab == null) {
      nodeTab = new NodeTab(tabName);
      tabContainerList.add(nodeTab);
    } else if (tabName == Config.TAB_NAME_HOT && hotTab == null) {
      hotTab = new HotTab(tabName);
      tabContainerList.add(hotTab);
    } else if (tabName == Config.TAB_NAME_USER && userTab == null) {
      userTab = new UserTab(tabName);
      tabContainerList.add(userTab);
    }
    setState(() {
      tabContainerList.sort((BaseTab widgetA, BaseTab widgetB) {
        if (widgetA.tabName == tabName) {
          return 1;
        } else {
          return 0;
        }
      });
    });
  }
}
