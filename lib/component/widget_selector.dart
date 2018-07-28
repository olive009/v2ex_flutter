import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';
import 'package:v2ex_flutter/component/rx_widgets.dart';

/// `WidgetSelector`is a convenience class that will return one of two Widgets based on the output of a `Stream<bool>`
/// This is pretty handy if you want to react to state change like enable/disable in you ViewModel and update
/// the View accordingly.
/// If you don't need builders for the alternative child widgets this class offers a more concise expression than `WidgetBuilderSelector`
class WidgetSelector extends StatelessWidget {
  final Stream<bool> buildEvents;
  final Widget onTrue;
  final Widget onFalse;

  /// Creates a new WidgetSelector instance
  /// `buildEvents` : `Stream<bool>`that signals that the this Widget should be updated
  /// `onTrue` : Widget that should be returned if an item with value true is received
  /// `onFalse`: Widget that should be returned if an item with value true is received
  const WidgetSelector({this.buildEvents, this.onTrue, this.onFalse, Key key})
      : assert(buildEvents != null),
        assert(onTrue != null),
        assert(onFalse != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: buildEvents,
        builder: (BuildContext context, AsyncSnapshot<bool> event) {
          if (event.hasData && event.data == true) {
            return onTrue;
          } else {
            return onFalse;
          }
        });
  }
}

/// `WidgetBuilderSelector`is a convenience class that will one of two builder methods based on the output of a `Stream<bool>`
/// This is pretty handy if you want to react to state change like enable/disable in you ViewModel and update
/// the View accordingly.
/// In comparrison to `WidgetSelector` this is best used if the alternative child widgets are large so that you don't want to have them created
/// without using them.
class WidgetBuilderSelector extends StatelessWidget {
  final Stream<bool> buildEvents;
  final WidgetBuilder onTrue;
  final WidgetBuilder onFalse;

  /// Creates a new WidgetBuilderSelector instance
  /// `buildEvents` : `Stream<bool>`that signals that the this Widget should be updated
  /// `onTrue` : builder that should be executed if an item with value true is received
  /// `onFalse`: builder that should be executed if an item with value true is received
  const WidgetBuilderSelector(
      {this.buildEvents, this.onTrue, this.onFalse, Key key})
      : assert(buildEvents != null),
        assert(onTrue != null),
        assert(onFalse != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: buildEvents,
        builder: (BuildContext context, AsyncSnapshot<bool> event) {
          if (event.hasData && event.data == true) {
            return onTrue(context);
          } else {
            return onFalse(context);
          }
        });
  }
}

/// Spinner/Busyindicator that reacts on the output of a `Stream<CommandResult<T>>`. It's made especially to work together with
/// `RxCommand` from the `rx_command`package.
/// it starts running as soon as an item with  `isExecuting==true` is received
/// until `isExecuting==true` is received.
/// To react on other possible states (`data, nodata, error`) that can be emitted it offers three option `Builder` methods
class RxCommandBuilder<T> extends StatefulWidget {
  final Stream<CommandResult<T>> commandResults;
  final BuilderFunction<T> dataBuilder;
  final BuilderFunction<Exception> errorBuilder;
  final BuilderFunction1 busyBuilder;
  final BuilderFunction1 placeHolderBuilder;

  final TargetPlatform platform;

  /// Creates a new `RxCommandBuilder` instance
  /// [commandResults] : `Stream<CommandResult<T>>` or a `RxCommand<T>` that issues `CommandResults`
  /// [busyBuilder] : Builder that will be called as soon as an event with `isExecuting==true`.
  /// [dataBuilder] : Builder that will be called as soon as an event with data is received. It will get passed the `data` feeld of the CommandResult.
  /// If this is null a `Container` will be created instead.
  /// [placeHolderBuilder] : Builder that will be called as soon as an event with `data==null` is received.
  /// If this is null a `Container` will be created instead.
  /// [dataBuilder] : Builder that will be called as soon as an event with an `error` is received. It will get passed the `error` feeld of the CommandResult.
  /// If this is null a `Container` will be created instead.
  const RxCommandBuilder({
    Key key,
    this.commandResults,
    this.platform,
    this.busyBuilder,
    this.dataBuilder,
    this.placeHolderBuilder,
    this.errorBuilder,
  })  : assert(commandResults != null),
        super(key: key);

  @override
  _RxCommandBuidlerState createState() {
    return new _RxCommandBuidlerState<T>(commandResults);
  }
}

class _RxCommandBuidlerState<T> extends State<RxCommandBuilder<T>> {
  StreamSubscription<CommandResult<T>> subscription;

  Stream<CommandResult<T>> commandResults;

  CommandResult<T> lastReceivedItem = new CommandResult<T>(null, null, false);

  _RxCommandBuidlerState(this.commandResults);

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
  void didUpdateWidget(RxCommandBuilder<T> oldWidget) {
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
    if (lastReceivedItem.isExecuting) {
      return widget.busyBuilder(context);
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
