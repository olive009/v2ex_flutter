import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/config.dart';

class BottomTabItem extends StatefulWidget {
  final IconData iconData;
  final String name;
  final AppModel appModel;
  bool isSelected;

  BottomTabItem(
      {this.iconData, this.name, this.appModel, this.isSelected = false});

  @override
  State<StatefulWidget> createState() {
    return new _BottomTabItemState();
  }
}

class _BottomTabItemState extends State<BottomTabItem> {
  final size = 32.0;
  Color _color = Config.tabUnselectedColor;
  StreamSubscription selectTabSubscription;

  updateSelected(String tabName) {
    if (tabName == widget.name && widget.isSelected) {
      //already selected current tab
      return;
    } else if (tabName != widget.name && !widget.isSelected) {
      //already not selected
      return;
    }
    print(tabName);
    setState(() {
      if (tabName == widget.name) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });
  }

  @override
  void dispose() {
    selectTabSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectTabSubscription == null) {
      selectTabSubscription =
          widget.appModel.selectTabCommand.results.listen((tabName) {
        updateSelected(tabName);
      });
    }
    _color = widget.isSelected
        ? Config.tabSelectedColor
        : Config.tabUnselectedColor;
    return InkResponse(
      splashColor: Colors.white30,
      onTap: () {
        widget.appModel.selectTabCommand.execute(widget.name);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(
              widget.iconData,
              size: size,
              color: _color,
            ),
            new Text(
              widget.name,
              style: TextStyle(color: _color),
            )
          ],
        ),
      ),
    );
  }
}
