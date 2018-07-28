import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:v2ex_flutter/app_model.dart';
import 'dart:async';

import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/dto/link_item.dart';
import 'package:v2ex_flutter/dto/topic.dart';

Future<AppModel> getIndexData(AppModel appModel) async {
  String url = appModel.currentUrl != null
      ? Config.root_url + appModel.currentUrl
      : Config.root_url;
  try {
    final http.Response response = await http.get(url);
    String body = (response.body);
    if (body == null || body.isEmpty || body.indexOf("Access Denied") != -1) {
      await Fluttertoast.showToast(msg: Config.MESSAGE_GET_DATA_FAILED);
      return null;
    }
    var document = parse(body);

    //获取所有tab
    if (appModel.tabList == null) {
      appModel.tabList = getTabList(document); //only update on the first time.
    }

//获取tab下面的sub-tab
    List<LinkItem> currentNodeList = new List<LinkItem>();
    List<dom.Element> cellList =
        document.getElementById("SecondaryTabs").getElementsByTagName('a');
    for (dom.Element cellElement in cellList) {
      LinkItem linkItem = getLinkItemFromElement(cellElement);
      currentNodeList.add(linkItem);
    }

//获取topic
    List<Topic> topicList = new List();
    List<dom.Element> topicElementList =
        document.getElementsByClassName("cell item");
    for (dom.Element topicElement in topicElementList) {
      String avatar =
          (topicElement.getElementsByClassName("avatar")[0].attributes['src']);

      dom.Element itemTitleElement = topicElement
          .getElementsByClassName("item_title")[0]
          .getElementsByTagName('a')[0];
      String link = itemTitleElement.attributes['href'];
      String title = itemTitleElement.innerHtml;

      String node = topicElement.getElementsByClassName("node")[0].innerHtml;

      dom.Element topicInfoSpan =
          topicElement.getElementsByClassName("topic_info")[0];
      List<dom.Element> strongElementList =
          topicInfoSpan.getElementsByTagName('strong');
      String replier;
      if (strongElementList.length > 1) {
        replier = strongElementList[1].getElementsByTagName('a')[0].innerHtml;
      }
      String member =
          strongElementList[0].getElementsByTagName('a')[0].innerHtml;
      String replyText = topicInfoSpan.text;

      String replyCount;
      List<dom.Element> replyCountElement =
          topicElement.getElementsByClassName("count_livid");
      if (replyCountElement != null && replyCountElement.length > 0) {
        replyCount = replyCountElement[0].innerHtml;
      }
      Topic topic = new Topic(
          avatar: avatar,
          itemTitle: title,
          member: member,
          replyText: replyText,
          replier: replier,
          replyCount: replyCount,
          link: link);
      topicList.add(topic);
    }

    //获取所有node
    if (appModel.allNodeList == null) {
      appModel.allNodeList = getAllNodeList(document);
    }

    //获取“今日热议主题”
    if (appModel.hotTopicList == null) {
      appModel.hotTopicList = getHotTopicList(document);
    }

    //获取“最热节点”
    if (appModel.hotNodeList == null) {
      appModel.hotNodeList = getHotNodeList(document);
    }

    //获取“最近新增节点”
    if (appModel.latestNodeList == null) {
      appModel.latestNodeList = getLatestNodeList(document);
    }

    //获取“最近新增节点”
    if (appModel.bottomLinkList == null) {
      appModel.bottomLinkList = getBottomLinkList(document);
    }

    appModel.currentNodeList = currentNodeList;
    appModel.topicList = topicList;
  } catch (e) {
    print(e);
    await Fluttertoast.showToast(msg: Config.MESSAGE_GET_DATA_FAILED);
  }
  return appModel;
}

List<LinkItem> getTabList(document) {
  List<LinkItem> tabList = new List<LinkItem>();
  List<dom.Element> tabElementList = document.getElementsByClassName("tab");
  dom.Element currentTab =
      document.getElementsByClassName("tab_current")[0]; //当前选中的Tab
  LinkItem currentLinkItem = getLinkItemFromElement(currentTab);
  tabList.add(currentLinkItem);
  for (dom.Element tabElement in tabElementList) {
    tabList.add(getLinkItemFromElement(tabElement));
  }
  return tabList;
}

Map<String, List<LinkItem>> getAllNodeList(document) {
  Map<String, List<LinkItem>> allNodeList = new Map();
  List<dom.Element> nodeTableList = document.getElementsByTagName("table");
  for (dom.Element cellElement in nodeTableList) {
    List<dom.Element> nameElement = cellElement.getElementsByClassName("fade");
    if (nameElement != null && nameElement.length == 1) {
      String name = (nameElement[0].innerHtml);
      List<LinkItem> nodeList = new List();
      List aList = cellElement.getElementsByTagName('a');
      for (dom.Element cellElement in aList) {
        LinkItem linkItem = getLinkItemFromElement(cellElement);
        nodeList.add(linkItem);
      }
      allNodeList[name] = nodeList;
    }
  }
  return allNodeList;
}

List<Topic> getHotTopicList(document) {
  List<Topic> hotTopicList = new List();
  List<dom.Element> tableList =
      document.getElementById("TopicsHot").getElementsByTagName('table');
  for (dom.Element element in tableList) {
    List<dom.Element> aList = element.getElementsByTagName('a');
    if (aList != null && aList.length == 2) {
      Topic topic = new Topic();
      topic.member = aList[0].attributes['href'];
      topic.avatar = aList[0].getElementsByTagName('img')[0].attributes['src'];
      topic.link = aList[1].attributes['href'];
      topic.itemTitle = aList[1].innerHtml;
      hotTopicList.add(topic);
    }
  }
  return hotTopicList;
}

List<LinkItem> getHotNodeList(document) {
  List<LinkItem> hotNodeList = new List();
  List<dom.Element> boxDivList = document.getElementsByClassName('box');
  for (dom.Element element in boxDivList) {
    List<dom.Element> cellDivList = element.getElementsByTagName('div');
    if (cellDivList != null && cellDivList.length > 0) {
      //find the "最热节点" span
      List<dom.Element> spanList = cellDivList[0].getElementsByTagName('span');
      if (spanList != null &&
          spanList.length > 0 &&
          spanList[0].innerHtml == Config.LABEL_HOT_NODE) {
        List<dom.Element> aList = element.getElementsByClassName("item_node");
        for (dom.Element aElement in aList) {
          LinkItem linkItem = new LinkItem();
          linkItem.name = aElement.innerHtml;
          linkItem.href = aElement.attributes['href'];
          hotNodeList.add(linkItem);
        }
      }
    }
  }
  return hotNodeList;
}

List<LinkItem> getLatestNodeList(document) {
  List<LinkItem> latestNodeList = new List();
  List<dom.Element> boxDivList = document.getElementsByClassName('box');
  for (dom.Element element in boxDivList) {
    List<dom.Element> cellDivList = element.getElementsByTagName('div');
    if (cellDivList != null && cellDivList.length > 0) {
      //find the "最近新增节点" span
      List<dom.Element> spanList = cellDivList[0].getElementsByTagName('span');
      if (spanList != null &&
          spanList.length > 0 &&
          spanList[0].innerHtml == Config.LABEL_LATEST_NODE) {
        List<dom.Element> aList = element.getElementsByClassName("item_node");
        for (dom.Element aElement in aList) {
          LinkItem linkItem = new LinkItem();
          linkItem.name = aElement.innerHtml;
          linkItem.href = aElement.attributes['href'];
          latestNodeList.add(linkItem);
        }
      }
    }
  }
  return latestNodeList;
}

List<LinkItem> getBottomLinkList(document) {
  List<LinkItem> linkList = new List();
  List<dom.Element> aList = document.getElementsByClassName('dark');
  for (dom.Element aElement in aList) {
    LinkItem linkItem = new LinkItem();
    linkItem.name = aElement.innerHtml;
    linkItem.href = aElement.attributes['href'];
    linkList.add(linkItem);
  }
  return linkList;
}

LinkItem getLinkItemFromElement(dom.Element element) {
  LinkItem linkItem = new LinkItem();
  linkItem.name = element.innerHtml;
  linkItem.href = (element.attributes['href']);
  return linkItem;
}
