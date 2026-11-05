import 'package:flutter/material.dart';

import 'automation_semantics.dart';

class ClickDetector extends StatelessWidget {
  const ClickDetector({
    this.child,
    super.key,
    this.onClick,
    this.onLongClick,
    this.highlightColor,
    this.semanticsIdentifier,
  });

  final Widget? child;
  final GestureTapCallback? onClick;
  final GestureLongPressCallback? onLongClick;
  final Color? highlightColor;
  final String? semanticsIdentifier;

  @override
  Widget build(BuildContext context) {
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: onClick != null || onLongClick != null,
      child: Material(
        color: Colors.transparent,
        textStyle: DefaultTextStyle.of(context).style,
        child: InkWell(
          highlightColor: highlightColor ?? Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onClick,
          onLongPress: onLongClick,
          child: child,
        ),
      ),
    );
  }
}
