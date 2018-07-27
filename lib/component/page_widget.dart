import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:v2ex_flutter/dto/page_dto.dart';

class PageWidget extends StatefulWidget {
  final PageDTO pageDTO;
  final Function getDataCallBack;

  PageWidget(this.pageDTO, this.getDataCallBack);

  @override
  State<StatefulWidget> createState() {
    return new _PageWidgetState(pageDTO);
  }
}

class _PageWidgetState extends State<PageWidget> {
  PageDTO pageDTO;

  _PageWidgetState(this.pageDTO);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: 32.0,
          height: 32.0,
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(new Radius.circular(4.0))),
          child: Center(
            child: new InkWell(
              child: new Icon(
                Icons.skip_previous,
                color: Colors.grey,
              ),
              onTap: () {
                if (pageDTO.currentPage - 1 > 0) {
                  pageDTO.currentPage -= 1;
                  widget.getDataCallBack(pageDTO);
                } else {
                  Fluttertoast.showToast(
                      msg: "已经是第一页",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1);
                }
              },
            ),
          ),
        ),
        new SizedBox(
          width: 20.0,
        ),
        new Container(
          width: 32.0,
          height: 32.0,
          decoration: new BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(new Radius.circular(4.0))),
          child: Center(
            child: Text(
              pageDTO.currentPage.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        new SizedBox(
          width: 20.0,
        ),
        new Container(
          width: 32.0,
          height: 32.0,
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(new Radius.circular(4.0))),
          child: Center(
            child: new InkWell(
              child: new Icon(
                Icons.skip_next,
                color: Colors.grey,
              ),
              onTap: () {
                if (pageDTO.currentPage + 1 > pageDTO.totalPage) {
                  Fluttertoast.showToast(
                      msg: "已经是最后一页",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1);
                } else {
                  pageDTO.currentPage += 1;
                  widget.getDataCallBack(pageDTO);
                }
              },
            ),
          ),
        ),
        new SizedBox(
          width: 20.0,
        ),
        new Text("共" + pageDTO.totalSize.toString() + "条")
      ],
    );
  }
}
