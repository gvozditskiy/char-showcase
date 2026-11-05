part of '../cards_feed_page.dart';

class _FeedCreateCharacterCard extends StatelessWidget {
  const _FeedCreateCharacterCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AutomationSemantics(
      identifier: 'cards_feed_create_character_card',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_FeedCharacterCard.radius),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [palette.surfaceFixedAccent, palette.surfaceFixedDarkAccent],
              ),
            ),
            child: _FeedCreateCharacterContent(onTap: onTap),
          ),
        ),
      ),
    );
  }
}

class _FeedCreateCharacterContent extends StatelessWidget {
  const _FeedCreateCharacterContent({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = cards_l10n.AppLocalizations.of(context);
    final text = context.appStyle.text;
    final foreground = context.palette.textOnSurfaceFixedWhite;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.cardsFeedCreateCharacterTitle,
              textAlign: TextAlign.center,
              style: text.h4.copyWith(color: foreground, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            _FeedPromoBenefit(
              icon: Icons.auto_fix_high_rounded,
              title: strings.cardsFeedCreateCharacterLook,
            ),
            const SizedBox(height: 20),
            _FeedPromoBenefit(
              icon: Icons.local_fire_department_rounded,
              title: strings.cardsFeedCreateCharacterPersonality,
            ),
            const SizedBox(height: 46),
            ThemedButton(
              text: strings.cardsFeedCreateCharacterButton,
              onPressed: onTap,
              size: ThemedButtonSize.xl,
              theme: ThemedButtonTheme.secondary(context),
              withShimmer: true,
              leadingIcon: const ThemedButtonIcon(icon: Icons.auto_fix_high_rounded),
              textStyle: text.h7.copyWith(fontWeight: FontWeight.w900),
              semanticsIdentifier: 'cards_feed_create_character_button',
            ),
          ],
        ),
      ),
    );
  }
}
