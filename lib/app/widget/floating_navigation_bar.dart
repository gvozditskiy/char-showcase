import 'dart:ui';

import 'package:common_ui/common_ui.dart';
import 'package:common_ui/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/nav_bar_data.dart';

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({required this.data, required this.onItemTapped, super.key});

  static const reservedHeight = _height + _bottomSpacing;
  static const _height = 57.0;
  static const _bottomSpacing = 10.0;
  static const _radius = 60.0;
  static const _selectionRadius = 52.0;
  static const _selectionAnimationDuration = Duration(milliseconds: 500);
  static const _cardsAsset = 'assets/images/ic_cards.svg';
  static const _createAsset = 'assets/images/ic_create.svg';
  static const _profileAsset = 'assets/images/ic_profile.svg';

  final NavBarData data;
  final ValueChanged<NavBarItem> onItemTapped;

  @override
  Widget build(BuildContext context) {
    final normalTheme = Theme.of(context);
    final normalColors = _FloatingNavigationColors.fromPalette(context.palette);
    final targetFeedThemeValue = data.selectedItem == NavBarItem.cards ? 1.0 : 0.0;

    return Theme(
      data: CharPalette.instance.toThemeData(isDark: true),
      child: Builder(
        builder: (darkContext) {
          final feedColors = _FloatingNavigationColors.fromPalette(darkContext.palette);
          return Theme(
            data: normalTheme,
            child: TweenAnimationBuilder<double>(
              duration: _selectionAnimationDuration,
              curve: AppCurves.fastInSlowOut,
              tween: Tween<double>(end: targetFeedThemeValue),
              builder: (context, feedThemeValue, _) {
                final colors = _FloatingNavigationColors.lerp(
                  normalColors,
                  feedColors,
                  feedThemeValue,
                );
                return CharPopScope(
                  interceptBack: data.selectedItem != data.items.firstOrNull,
                  onPopInvoked: (bool systemPopBlocked, _) {
                    if (systemPopBlocked) {
                      onItemTapped(data.items.first);
                    }
                  },
                  child: _buildContent(context, colors),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, _FloatingNavigationColors colors) {
    return Padding(
      padding: CharPadding.of(
        context,
      ).add(const EdgeInsets.only(bottom: _bottomSpacing, left: 20, right: 20)),
      child: Center(
        child: SizedBox(
          height: _height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: colors.borderColor,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    color: colors.lightOverlayColor,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_radius),
                      color: colors.darkOverlayColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemCount = data.items.length;
                          final selectedIndex = data.items.indexOf(data.selectedItem);
                          final itemWidth = constraints.maxWidth / itemCount;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              AnimatedPositionedDirectional(
                                duration: _selectionAnimationDuration,
                                curve: AppCurves.fastInSlowOut,
                                start: itemWidth * selectedIndex.clamp(0, itemCount - 1),
                                top: 0,
                                bottom: 0,
                                width: itemWidth,
                                child: _FloatingNavigationSelectionPill(
                                  color: colors.selectionPillColor,
                                ),
                              ),
                              Row(
                                children: data.items
                                    .map((item) => _buildItem(context, item, colors))
                                    .toList(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, NavBarItem item, _FloatingNavigationColors colors) {
    return Expanded(
      child: _FloatingNavigationButton(
        name: switch (item) {
          NavBarItem.cards => context.l10n.navBarFeed,
          NavBarItem.cyoc => context.l10n.navBarCreate,
          NavBarItem.settings => context.l10n.navBarSettings,
        },
        icon: switch (item) {
          NavBarItem.cards => const _FloatingNavigationAssetIcon(assetName: _cardsAsset),
          NavBarItem.cyoc => const _FloatingNavigationAssetIcon(assetName: _createAsset),
          NavBarItem.settings => const _FloatingNavigationAssetIcon(assetName: _profileAsset),
        },
        semanticsIdentifier: switch (item) {
          NavBarItem.cards => 'root_tab_cards_button',
          NavBarItem.cyoc => 'root_tab_create_button',
          NavBarItem.settings => 'root_tab_settings_button',
        },
        selected: data.selectedItem == item,
        animationDuration: _selectionAnimationDuration,
        colors: colors,
        onTap: () => onItemTapped(item),
      ),
    );
  }
}

class _FloatingNavigationColors {
  const _FloatingNavigationColors({
    required this.borderColor,
    required this.lightOverlayColor,
    required this.darkOverlayColor,
    required this.unselectedIconColor,
    required this.selectedIconColor,
    required this.unselectedTextColor,
    required this.selectedTextColor,
    required this.selectionPillColor,
  });

  factory _FloatingNavigationColors.fromPalette(ContextAwarePalette palette) {
    return _FloatingNavigationColors(
      borderColor: palette.outlineFixedMedium,
      lightOverlayColor: palette.surfaceTranslucentFixedWhite.withAlphaPercent(10),
      darkOverlayColor: palette.surfaceTranslucentFixedBlack.withAlphaPercent(10),
      unselectedIconColor: palette.iconOnSurfaceFixedSecondary,
      selectedIconColor: palette.iconOnSurfacePrimary,
      unselectedTextColor: palette.textOnSurfaceMediumGrey,
      selectedTextColor: palette.textOnSurfacePrimary,
      selectionPillColor: palette.surfaceWhite,
    );
  }

  factory _FloatingNavigationColors.lerp(
    _FloatingNavigationColors begin,
    _FloatingNavigationColors end,
    double value,
  ) {
    return _FloatingNavigationColors(
      borderColor: Color.lerp(begin.borderColor, end.borderColor, value)!,
      lightOverlayColor: Color.lerp(begin.lightOverlayColor, end.lightOverlayColor, value)!,
      darkOverlayColor: Color.lerp(begin.darkOverlayColor, end.darkOverlayColor, value)!,
      unselectedIconColor: Color.lerp(begin.unselectedIconColor, end.unselectedIconColor, value)!,
      selectedIconColor: Color.lerp(begin.selectedIconColor, end.selectedIconColor, value)!,
      unselectedTextColor: Color.lerp(begin.unselectedTextColor, end.unselectedTextColor, value)!,
      selectedTextColor: Color.lerp(begin.selectedTextColor, end.selectedTextColor, value)!,
      selectionPillColor: Color.lerp(begin.selectionPillColor, end.selectionPillColor, value)!,
    );
  }

  final Color borderColor;
  final Color lightOverlayColor;
  final Color darkOverlayColor;
  final Color unselectedIconColor;
  final Color selectedIconColor;
  final Color unselectedTextColor;
  final Color selectedTextColor;
  final Color selectionPillColor;
}

class _FloatingNavigationButton extends StatelessWidget {
  const _FloatingNavigationButton({
    required this.name,
    required this.icon,
    required this.selected,
    required this.animationDuration,
    required this.colors,
    required this.onTap,
    required this.semanticsIdentifier,
  });

  final String name;
  final Widget icon;
  final bool selected;
  final Duration animationDuration;
  final _FloatingNavigationColors colors;
  final VoidCallback onTap;
  final String semanticsIdentifier;

  @override
  Widget build(BuildContext context) {
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: true,
      selected: selected,
      child: ClickDetector(
        onClick: onTap,
        child: SizedBox.expand(
          child: TweenAnimationBuilder<double>(
            duration: animationDuration,
            curve: AppCurves.fastInSlowOut,
            tween: Tween<double>(end: selected ? 1 : 0),
            builder: (context, selectionValue, _) {
              final iconColor = Color.lerp(
                colors.unselectedIconColor,
                colors.selectedIconColor,
                selectionValue,
              )!;
              final textColor = Color.lerp(
                colors.unselectedTextColor,
                colors.selectedTextColor,
                selectionValue,
              )!;
              return IconTheme(
                data: IconThemeData(color: iconColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FloatingNavigationIconTheme(color: iconColor, child: icon),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.appStyle.text.caption2.medium.copyWith(color: textColor),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FloatingNavigationSelectionPill extends StatelessWidget {
  const _FloatingNavigationSelectionPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(FloatingNavigationBar._selectionRadius),
      ),
    );
  }
}

class _FloatingNavigationIconTheme extends StatelessWidget {
  const _FloatingNavigationIconTheme({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: color),
      child: child,
    );
  }
}

class _FloatingNavigationAssetIcon extends StatelessWidget {
  const _FloatingNavigationAssetIcon({required this.assetName});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: 30,
      height: 30,
      colorFilter: ColorFilter.mode(IconTheme.of(context).color!, BlendMode.srcIn),
    );
  }
}
