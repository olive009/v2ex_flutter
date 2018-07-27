import 'package:flutter/material.dart';
import 'package:v2ex_flutter/app_model.dart';

class AppViewModel extends InheritedWidget {
  final AppModel appModel;

  const AppViewModel({Key key, @required this.appModel, @required Widget child})
      : assert(appModel != null),
        assert(child != null),
        super(key: key, child: child);

  static AppModel of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AppViewModel) as AppViewModel)
          .appModel;

  @override
  bool updateShouldNotify(AppViewModel oldWidget) =>
      appModel != oldWidget.appModel;
}
