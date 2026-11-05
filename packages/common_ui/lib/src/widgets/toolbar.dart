import 'package:flutter/material.dart';

import '../styles.dart';
import 'back_button.dart';
import 'close_button.dart';

class CharToolbar extends StatelessWidget implements PreferredSizeWidget {
  const CharToolbar({
    super.key,
    this.titleWidget,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.onBackClick,
    this.onCloseClick,
    this.fixedWhite = false,
    this.decoration,
    this.height = _defaultHeight,
    this.trailingPadding = _defaultTrailingPadding,
    this.leadingPadding = _defaultLeadingPadding,
    this.title,
    this.bottom,
    this.centerTitle = true,
    this.titlePadding = _defaultTitlePadding,
    this.withShadow = false,
    this.padding = EdgeInsets.zero,
    this.backWithBackground = false,
    this.closeButtonSemanticsIdentifier,
  }) : assert(title == null || titleWidget == null, 'Provide either title or titleWidget');

  const CharToolbar.bottomSheet({
    super.key,
    this.titleWidget,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.onBackClick,
    this.onCloseClick,
    this.fixedWhite = false,
    this.decoration,
    this.height = _bottomSheetDefaultHeight,
    this.trailingPadding = _defaultBottomSheetTrailingPadding,
    this.leadingPadding = _defaultBottomSheetLeadingPadding,
    this.title,
    this.bottom,
    this.centerTitle = true,
    this.titlePadding = _defaultTitlePadding,
    this.withShadow = false,
    this.padding = EdgeInsets.zero,
    this.backWithBackground = false,
    this.closeButtonSemanticsIdentifier,
  }) : assert(title == null || titleWidget == null, 'Provide either title or titleWidget');

  final VoidCallback? onBackClick;
  final VoidCallback? onCloseClick;
  final Widget? titleWidget;
  final List<Widget> leadingActions;
  final List<Widget> trailingActions;
  final bool fixedWhite;
  final BoxDecoration? decoration;
  final double height;
  final EdgeInsets trailingPadding;
  final EdgeInsets leadingPadding;
  final EdgeInsets titlePadding;
  final EdgeInsets padding;
  final String? title;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final bool withShadow;
  final bool backWithBackground;
  final String? closeButtonSemanticsIdentifier;

  static const double _defaultHeight = 64;
  static const double _bottomSheetDefaultHeight = 54;
  static const EdgeInsets _defaultTrailingPadding = EdgeInsets.only(right: 20);
  static const EdgeInsets _defaultLeadingPadding = EdgeInsets.only(left: 20);
  static const EdgeInsets _defaultTitlePadding = EdgeInsets.zero;
  static const EdgeInsets _defaultBottomSheetTrailingPadding = EdgeInsets.only(right: 10);
  static const EdgeInsets _defaultBottomSheetLeadingPadding = EdgeInsets.only(left: 10);

  static double get defaultHeight => _defaultHeight;

  @override
  Widget build(BuildContext context) {
    final style = AppStyle.of(context);
    final systemPadding = MediaQuery.paddingOf(context);
    final shouldShowBackButton = onBackClick != null;
    final shouldShowCloseButton = onCloseClick != null;
    final leading = _Actions(
      padding: leadingPadding,
      actionItemPadding: EdgeInsets.only(right: style.spacing.space3),
      children: [
        if (shouldShowBackButton)
          CharBackButton(
            onBackClick: onBackClick!,
            withShadow: withShadow,
            withBackground: backWithBackground,
            fixedWhite: fixedWhite,
            semanticsIdentifier: 'toolbar_back_button',
          ),
        ...leadingActions,
      ],
    );
    final trailing = _Actions(
      padding: trailingPadding,
      actionItemPadding: EdgeInsets.only(left: style.spacing.space3),
      children: [
        ...trailingActions,
        if (shouldShowCloseButton)
          CharCloseButton(
            onTap: onCloseClick,
            color: fixedWhite ? context.palette.iconOnSurfaceFixedWhite : null,
            semanticsIdentifier: closeButtonSemanticsIdentifier ?? 'toolbar_close_button',
          ),
      ],
    );
    Widget? middle;
    if (titleWidget != null || title != null) {
      middle = Padding(
        padding: titlePadding,
        child: DefaultTextStyle(
          style: style.text.h7.copyWith(color: context.palette.textOnSurfacePrimary),
          child: title != null ? Text(title!) : titleWidget!,
        ),
      );
    }
    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.only(top: systemPadding.top),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height,
              child: Padding(
                padding: padding,
                child: NavigationToolbar(
                  centerMiddle: centerTitle,
                  leading: leading,
                  middle: middle,
                  trailing: trailing,
                  middleSpacing: 0,
                ),
              ),
            ),
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
}

class _Actions extends StatelessWidget {
  const _Actions({required this.children, required this.actionItemPadding, required this.padding});

  final List<Widget> children;

  final EdgeInsets actionItemPadding;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children
            .map((action) => Padding(padding: actionItemPadding, child: action))
            .toList(),
      ),
    );
  }
}
