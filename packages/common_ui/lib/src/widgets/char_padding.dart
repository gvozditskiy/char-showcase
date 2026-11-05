import 'package:flutter/material.dart';

class CharPadding extends InheritedWidget {
  const CharPadding(this.padding, {required super.child, super.key});

  final EdgeInsets padding;

  static EdgeInsets of(BuildContext context, {bool includeMedia = true}) {
    final CharPadding? result = context.dependOnInheritedWidgetOfExactType<CharPadding>();
    assert(result != null, 'No CharPadding found in context');
    return result!.padding + (includeMedia ? MediaQuery.paddingOf(context) : EdgeInsets.zero);
  }

  @override
  bool updateShouldNotify(CharPadding oldWidget) {
    return oldWidget.padding.top != padding.top ||
        oldWidget.padding.bottom != padding.bottom ||
        oldWidget.padding.right != padding.right ||
        oldWidget.padding.left != padding.left;
  }
}
