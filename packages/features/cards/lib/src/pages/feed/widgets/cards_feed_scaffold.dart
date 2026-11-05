part of '../cards_feed_page.dart';

class _FeedScaffold extends StatelessWidget {
  const _FeedScaffold({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AutomationSemantics(
      identifier: 'cards_feed_root_screen',
      child: ColoredBox(
        color: context.palette.surfaceFixedBlackBg,
        child: Stack(children: [...children, const _FeedTopOverlay()]),
      ),
    );
  }
}
