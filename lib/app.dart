import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';
import 'package:v2ex_flutter/app_scaffold.dart';
import 'package:v2ex_flutter/app_view_model.dart';
import 'package:v2ex_flutter/config.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  AppModel appModel;

  @override
  void initState() {
    appModel = new AppModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AppViewModel(
      appModel: appModel,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Config.backgroundColor,
            iconTheme: IconThemeData(color: Colors.white)),
//        routes: <String, WidgetBuilder>{
//          Config.ROUTE_LOGIN: (BuildContext context) => new LoginPage(),
//        },
        home: new AppScaffold(),
      ),
    );
  }
}
