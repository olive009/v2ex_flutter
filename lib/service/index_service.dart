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
      await Fluttertoast.showToast(msg: "获取数据失败，请重试！");
      return null;
    }
    var document = parse(body);

//获取所有tab
    List<LinkItem> tabList = new List<LinkItem>();
    List<dom.Element> tabElementList = document.getElementsByClassName("tab");
    dom.Element currentTab =
        document.getElementsByClassName("tab_current")[0]; //当前选中的Tab
    LinkItem currentLinkItem = getLinkItemFromElement(currentTab);
    tabList.add(currentLinkItem);
    for (dom.Element tabElement in tabElementList) {
      tabList.add(getLinkItemFromElement(tabElement));
    }

//获取tab下面的sub-tab
    List<LinkItem> nodeList = new List<LinkItem>();
    List<dom.Element> cellList =
        document.getElementById("SecondaryTabs").getElementsByTagName('a');
    for (dom.Element cellElement in cellList) {
      LinkItem linkItem = getLinkItemFromElement(cellElement);
      nodeList.add(linkItem);
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

    appModel.tabList??= tabList;//only update on the first time.
    appModel.currentNodeList = nodeList;
    appModel.topicList = topicList;
  } catch (e) {
    await Fluttertoast.showToast(msg: "获取数据失败，请重试！");
  }
  return appModel;
}

LinkItem getLinkItemFromElement(dom.Element element) {
  LinkItem linkItem = new LinkItem();
  linkItem.name = element.innerHtml;
  linkItem.href = (element.attributes['href']);
  return linkItem;
}
