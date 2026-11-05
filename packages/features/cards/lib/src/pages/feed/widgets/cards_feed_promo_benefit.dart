part of '../cards_feed_page.dart';

class _FeedPromoBenefit extends StatelessWidget {
  const _FeedPromoBenefit({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final foreground = context.palette.textOnSurfaceFixedWhite;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: foreground),
          const SizedBox(width: 20),
          Expanded(
            child: Text(title, style: context.appStyle.text.subtitle2.copyWith(color: foreground)),
          ),
        ],
      ),
    );
  }
}
