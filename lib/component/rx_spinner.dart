import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';
import 'package:v2ex_flutter/component/rx_widgets.dart';

/// Spinner/Busyindicator that reacts on the output of a `Stream<bool>` it starts running as soon as a `true` value is received
/// until the next `false`is emitted. If the Spinner should replace another Widget while Spinning this widget can be passed as `normal` parameter.
/// `RxSpinner` also adapts to the current or specified platform look.
/// Needless to say that `RxSpinner` is ideal in combination with `RxCommand's` `isExecuting` Observable
class RxSpinner extends StatelessWidget {
  final Stream<bool> busyEvents;
  final Widget normal;

  final TargetPlatform platform;

  final double radius;

  final Color backgroundColor;
  final Animation<Color> valueColor;
  final double strokeWidth;
  final double value;

  /// Creates a new RxSpinner instance
  /// `busyEvents` : `Stream<bool>` that controls the activity of the Spinner. On receiving `true` it replaces the `normal` widget
  ///  and starts running undtil it receives a `false`value.
  /// `platform`  : defines platorm style of the Spinner. If this is null or not provided the style of the current platform will be used
  /// `radius`    : radius of the Spinner
  /// `normal`    : Widget that should be displayed while the Spinner is not active. If this is null a `Container` will be created instead.
  ///  all other parameters please see https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html
  ///  they are ignored if the platform style is iOS.
  const RxSpinner(
      {this.busyEvents,
      this.platform,
      this.radius = 20.0,
      this.backgroundColor,
      this.value,
      this.valueColor,
      this.strokeWidth: 4.0,
      this.normal,
      Key key})
      : assert(busyEvents != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var platformToUse = platform != null ? platform : defaultTargetPlatform;

    var spinner = (platformToUse == TargetPlatform.iOS)
        ? new CupertinoActivityIndicator(
            radius: this.radius,
          )
        : new CircularProgressIndicator(
            backgroundColor: backgroundColor,
            strokeWidth: strokeWidth,
            valueColor: valueColor,
            value: value,
          );

    return new WidgetSelector(
      buildEvents: busyEvents,
      onTrue: new Center(
          child: new Container(
              width: this.radius * 2, height: this.radius * 2, child: spinner)),
      onFalse: normal != null ? normal : new Container(),
    );
  }
}

typedef BuilderFunction<T> = Widget Function(BuildContext context, T data);
typedef BuilderFunction1 = Widget Function(BuildContext context);

/// Spinner/Busyindicator that reacts on the output of a `Stream<CommandResult<T>>`. It's made especially to work together with
/// `RxCommand` from the `rx_command`package.
/// it starts running as soon as an item with  `isExecuting==true` is received
/// until `isExecuting==true` is received.
/// To react on other possible states (`data, nodata, error`) that can be emitted it offers three option `Builder` methods
class RxLoader<T> extends StatefulWidget {
  final Stream<CommandResult<T>> commandResults;
  final BuilderFunction<T> dataBuilder;
  final BuilderFunction<Exception> errorBuilder;
  final BuilderFunction1 placeHolderBuilder;

  final TargetPlatform platform;

  final double radius;

  final Color backgroundColor;
  final Animation<Color> valueColor;
  final double strokeWidth;
  final double value;

  final Key spinnerKey;

  /// Creates a new `RxLoader` instance
  /// [commandResults] : `Stream<CommandResult<T>>` or a `RxCommand<T>` that issues `CommandResults`
  /// [platform]  : defines platorm style of the Spinner. If this is null or not provided the style of the current platform will be used
  /// [radius]    : radius of the Spinner
  /// [dataBuilder] : Builder that will be called as soon as an event with data is received. It will get passed the `data` feeld of the CommandResult.
  /// If this is null a `Container` will be created instead.
  /// [placeHolderBuilder] : Builder that will be called as soon as an event with `data==null` is received.
  /// If this is null a `Container` will be created instead.
  /// [dataBuilder] : Builder that will be called as soon as an event with an `error` is received. It will get passed the `error` feeld of the CommandResult.
  /// If this is null a `Container` will be created instead.
  /// [spinnerKey] Widget key of the Spinner Widget of the RxLoader. This can be usefull if you want to check in UI Tests if the Spinner is visible.
  ///  all other parameters please see https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html
  ///  they are ignored if the platform style is iOS.
  const RxLoader({
    Key key,
    this.spinnerKey,
    this.commandResults,
    this.platform,
    this.radius = 20.0,
    this.backgroundColor,
    this.value,
    this.valueColor,
    this.strokeWidth: 4.0,
    this.dataBuilder,
    this.placeHolderBuilder,
    this.errorBuilder,
  })  : assert(commandResults != null),
        super(key: key);

  @override
  _RxLoaderState createState() {
    return new _RxLoaderState<T>(commandResults);
  }
}

class _RxLoaderState<T> extends State<RxLoader<T>> {
  StreamSubscription<CommandResult<T>> subscription;

  Stream<CommandResult<T>> commandResults;

  CommandResult<T> lastReceivedItem = new CommandResult<T>(null, null, false);

  _RxLoaderState(this.commandResults);

  @override
  void initState() {
    subscription = commandResults.listen((result) {
      setState(() {
        lastReceivedItem = result;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(RxLoader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    subscription?.cancel();

    subscription = commandResults.listen((result) {
      setState(() {
        lastReceivedItem = result;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var platformToUse =
        widget.platform != null ? widget.platform : defaultTargetPlatform;

    var spinner = (platformToUse == TargetPlatform.iOS)
        ? new CupertinoActivityIndicator(
            key: widget.spinnerKey,
            radius: this.widget.radius,
          )
        : new CircularProgressIndicator(
            key: widget.spinnerKey,
            backgroundColor: widget.backgroundColor,
            strokeWidth: widget.strokeWidth,
            valueColor: widget.valueColor,
            value: widget.value,
          );
    if (lastReceivedItem.isExecuting) {
      return new Center(
          child: new Container(
              width: this.widget.radius * 2,
              height: this.widget.radius * 2,
              child: spinner));
    }
    if (lastReceivedItem.hasData) {
      if (widget.dataBuilder != null) {
        return widget.dataBuilder(context, lastReceivedItem.data);
      }
    }

    if (!lastReceivedItem.hasData && !lastReceivedItem.hasError) {
      if (widget.placeHolderBuilder != null) {
        return widget.placeHolderBuilder(context);
      }
    }

    if (lastReceivedItem.hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder(context, lastReceivedItem.error);
      }
    }

    // should never get here
    assert(false, "never should get here");
    return new Container();
  }
}
