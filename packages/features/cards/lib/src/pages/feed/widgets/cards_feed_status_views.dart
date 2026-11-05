part of '../cards_feed_page.dart';

class _FeedLoadingView extends StatelessWidget {
  const _FeedLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CharLoader(dimension: 54));
  }
}

class _FeedEmptyView extends StatelessWidget {
  const _FeedEmptyView({
    required this.title,
    required this.description,
    required this.actionTitle,
    required this.onRetry,
  });

  final String title;
  final String description;
  final String actionTitle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.appStyle.text.h5.copyWith(color: palette.textOnSurfaceFixedWhite),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: context.appStyle.text.p2.copyWith(color: palette.textOnSurfaceFixedSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ThemedButton(
              text: actionTitle,
              onPressed: onRetry,
              theme: ThemedButtonTheme.fixedWhite(context),
              textStyle: context.appStyle.text.subtitle1,
              semanticsIdentifier: 'cards_feed_empty_action_button',
            ),
          ],
        ),
      ),
    );
  }
}
