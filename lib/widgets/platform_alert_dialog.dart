import 'dart:io';
import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/widgets/platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDialog extends PlatformWidget {
  @required
  final String title;
  @required
  final String content;
  final String cancelButtonText;
  @required
  final String defaultActionText;

  PlatformDialog({
    this.title,
    this.content,
    this.cancelButtonText,
    this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          );
  }

  @override
  Widget buildCupertinoWidgets(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _builActions(context),
    );
  }

  @override
  Widget buildMaterialWidgets(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _builActions(context));
  }

  List<Widget> _builActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelButtonText != null) {
      actions.add(PlatformDialogActions(
        child: Text(cancelButtonText),
        onPressed: () => Navigator.of(context).pop(false),
      ));
    }
    actions.add(PlatformDialogActions(
      child: Text(defaultActionText),
      onPressed: () => Navigator.of(context).pop(true),
    ));
    return actions;
  }
}

class PlatformDialogActions extends PlatformWidget {
  PlatformDialogActions({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;
  @override
  Widget buildCupertinoWidgets(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidgets(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
