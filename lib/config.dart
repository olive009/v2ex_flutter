import 'package:flutter/material.dart';

class Config {
  static const Color backgroundColor = Color.fromRGBO(235, 235, 235, 1.0);
  static const Color tabSelectedColor = Colors.blue;
  static const Color panelHeaderColor = Colors.lightBlue;
  static const Color tabUnselectedColor = Colors.grey;

  static const double avatarSize = 48.0;

  static const String appName = "V2EX = way to explore";
  static const String root_url = "https://www.v2ex.com";
  static const String login_url = "https://www.v2ex.com/signin";
  static const String search_url = "https://www.google.com/search?q=site:v2ex.com/t%20";

  static const String TAB_NAME_INDEX = "主页";
  static const String TAB_NAME_NODE = "节点";
  static const String TAB_NAME_HOT = "热门";
  static const String TAB_NAME_USER = "我的";

  static const String LABEL_TODAY_HOT_TOPIC = "今日热议主题";
  static const String LABEL_HOT_NODE = "最热节点";
  static const String LABEL_LATEST_NODE = "最近新增节点";

  static const String MESSAGE_GET_DATA_FAILED = "获取数据失败，请重试！";
}
