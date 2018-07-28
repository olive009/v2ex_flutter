import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/config.dart';
import 'package:v2ex_flutter/tab/base_tab.dart';

class UserTab extends BaseTab {
  UserTab(String tabName) {
    super.tabName = tabName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _UserTabState();
  }
}

class _UserTabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Config.backgroundColor,
        child: new Center(child: getBodyWidget(context)));
  }

  Widget getBodyWidget(BuildContext context) {
    Color bgColor = Colors.white;
//    Image logoImage = new Image.asset(
//      'images/logo.png',
//      height: 60.0,
//      width: 60.0,
//    );
    Color firstColor = new Color.fromARGB(255, 237, 183, 30);
    Color secondColor = new Color.fromARGB(255, 44, 127, 189);
    TextStyle logoTextStyle = new TextStyle(
        color: firstColor, fontSize: 32.0, fontWeight: FontWeight.w500);
    TextStyle websiteTextStyle = new TextStyle(
        color: secondColor, fontSize: 20.0, fontWeight: FontWeight.w500);

    return new ListView(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 40.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //logo Row start
              new Padding(
                padding: new EdgeInsets.only(top: 40.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    logoImage,
                    new Padding(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            Config.root_url.replaceAll("https://", ""),
                            style: logoTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //logo Row end
              new Divider(
                height: 20.0,
              ),
              //account Row start
              new Container(
                padding: new EdgeInsets.all(1.0),
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0)),
                    color: firstColor),
                height: 40.0,
                child: new Container(
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(20.0)),
                      color: bgColor),
                  padding: new EdgeInsets.symmetric(horizontal: 14.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.phone_android, color: firstColor),
                      new Container(
                        margin: new EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      new Expanded(
                          child: new TextField(
                        style: Theme.of(context).textTheme.subhead.merge(
                            new TextStyle(color: secondColor, fontSize: 18.0)),
                        controller: new TextEditingController(text: ""),
                        decoration: new InputDecoration.collapsed(
                          hintText: '请输入账号',
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              //account Row end

              //password Row start
              new Container(
                margin: new EdgeInsets.only(top: 20.0),
                padding: new EdgeInsets.all(1.0),
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0)),
                    color: firstColor),
                height: 40.0,
                child: new Container(
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(20.0)),
                      color: bgColor),
                  padding: new EdgeInsets.symmetric(horizontal: 14.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.lock, color: firstColor),
                      new Container(
                        margin: new EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      new Expanded(
                          child: new TextField(
                        style: Theme.of(context).textTheme.subhead.merge(
                            new TextStyle(color: secondColor, fontSize: 18.0)),
                        controller: new TextEditingController(text: ""),
                        obscureText: true,
                        decoration: new InputDecoration.collapsed(
                          hintText: '请输入密码',
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              //password Row end
              new Divider(
                height: 20.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Expanded(child: new Center()),
                  new RaisedButton(
                    onPressed: () {},
                    child: new Text(
                      '现在注册',
                    ),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new RaisedButton(
                    color: Colors.lightGreen,
                    onPressed: () {},
                    child: new Text('登录',
                        style: Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .merge(new TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
