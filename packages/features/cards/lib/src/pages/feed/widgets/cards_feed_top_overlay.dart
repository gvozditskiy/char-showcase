part of '../cards_feed_page.dart';

class _FeedTopOverlay extends StatelessWidget {
  const _FeedTopOverlay();

  static const _safeAreaInset = 5.0;
  static const _minTopInset = 20.0;
  static const _contentHeight = 40.0;

  static double topInsetOf(BuildContext context) =>
      max(MediaQuery.paddingOf(context).top + _safeAreaInset, _minTopInset);

  static double bottomEdgeOf(BuildContext context) => topInsetOf(context) + _contentHeight;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Positioned(
      top: topInsetOf(context),
      left: 20,
      right: 20,
      child: AutomationSemantics(
        identifier: 'cards_feed_top_overlay',
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            cards_l10n.AppLocalizations.of(context).cardsFeedTitle,
            style: context.appStyle.text.h5.copyWith(color: palette.textOnSurfaceFixedWhite),
          ),
        ),
      ),
    );
  }
}
