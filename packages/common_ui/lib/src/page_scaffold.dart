import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/background.dart';
import 'widgets/char_padding.dart';

const _bottomPadding = 15.0;

// ignore: avoid_positional_boolean_parameters
typedef PageScaffoldWidgetBuilder = Widget Function(BuildContext context, bool kbOpened);

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    required this.builder,
    super.key,
    this.toolbar,
    this.extendBodyBehindToolbar = false,
    this.resizeToAvoidBottomInset,
    this.footer,
    this.floatingFooter,
    this.footerPadding = _defaultFooterPadding,
    this.floatingFooterPadding = _defaultFloatingFooterPadding,
    this.background = const CharBackground(),
    this.hideFloatingWhenKbOpened = false,
    this.useOnlyImePaddingWhenKbOpened = false,
  });

  static const _defaultFloatingFooterPadding = EdgeInsets.only(right: 20, left: 20);
  static const _defaultFooterPadding = EdgeInsets.only(right: 20, left: 20);

  final PreferredSizeWidget? toolbar;
  final PreferredSizeWidget? floatingFooter;
  final EdgeInsets footerPadding;
  final EdgeInsets floatingFooterPadding;
  final PageScaffoldWidgetBuilder builder;
  final bool extendBodyBehindToolbar;
  final bool? resizeToAvoidBottomInset;
  final Widget? background;
  final Widget? footer;
  final bool hideFloatingWhenKbOpened;
  final bool useOnlyImePaddingWhenKbOpened;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final toolbarPadding = extendBodyBehindToolbar || toolbar == null
        ? 0.0
        : toolbar!.preferredSize.height;
    final kbOpened = MediaQuery.viewInsetsOf(context).bottom != 0;

    final charBottomPadding = floatingFooter == null
        ? 0.0
        : floatingFooter!.preferredSize.height + floatingFooterPadding.vertical + _bottomPadding;

    Widget body = CharPadding(
      CharPadding.of(context, includeMedia: false) +
          EdgeInsets.only(top: toolbarPadding, bottom: charBottomPadding),
      child: Builder(builder: (context) => builder(context, kbOpened)),
    );
    if (footer != null) {
      body = Column(
        children: [
          Expanded(child: body),
          Padding(
            padding: footerPadding + EdgeInsets.only(bottom: padding.bottom),
            child: footer,
          ),
        ],
      );
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (background != null) Positioned.fill(child: background!),
        Positioned.fill(
          child: Scaffold(
            appBar: toolbar,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: extendBodyBehindToolbar,
            extendBody: true,
            body: body,
          ),
        ),
        if (floatingFooter != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              ignoring: hideFloatingWhenKbOpened && kbOpened,
              child: AnimatedOpacity(
                opacity: hideFloatingWhenKbOpened && kbOpened ? 0 : 1,
                duration: Duration(milliseconds: kbOpened ? 0 : 100),
                child: Padding(
                  padding:
                      EdgeInsets.only(
                        bottom: _platformBottomPadding(
                          context,
                          withIme: kbOpened,
                          useOnlyIme: useOnlyImePaddingWhenKbOpened,
                        ),
                      ) +
                      floatingFooterPadding,
                  child: floatingFooter,
                ),
              ),
            ),
          ),
      ],
    );
  }

  double _platformBottomPadding(
    BuildContext context, {
    required bool withIme,
    bool useOnlyIme = false,
  }) {
    if (useOnlyIme) {
      return MediaQuery.viewInsetsOf(context).bottom;
    }

    final double iOsPadding = withIme ? _bottomPadding : 5;
    final double padding = defaultTargetPlatform == TargetPlatform.android
        ? _bottomPadding
        : iOsPadding;
    return MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom + padding;
  }
}
