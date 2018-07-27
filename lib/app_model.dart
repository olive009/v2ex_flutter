import 'package:v2ex_flutter/config.dart';
import 'package:rx_command/rx_command.dart';
import 'package:v2ex_flutter/dto/link_item.dart';
import 'package:v2ex_flutter/dto/topic.dart';
import 'package:v2ex_flutter/service/app_service.dart';

class AppModel {
  List<LinkItem> tabList;
  List<LinkItem> currentNodeList;
  String currentUrl;
  List<Topic> topicList;

  RxCommand<String,String> selectTabCommand;
  RxCommand<AppModel,AppModel> getIndexDataCommand;
  AppModel() {
    //declaration start
    selectTabCommand = RxCommand.createSync3((tabName) => tabName);
    getIndexDataCommand = RxCommand.createAsync3(getIndexData);
    //declaration end

    //execution start
    //execution end

  }
}
