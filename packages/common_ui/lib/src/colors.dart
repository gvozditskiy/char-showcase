import 'package:flutter/material.dart';

import 'extensions/color_extensions.dart';

class CharPalette {
  CharPalette._();

  static final CharPalette _instance = CharPalette._();
  static CharPalette get instance => _instance;

  static const Color accent100 = Color(0xFFFFFFFF);
  static const Color accent95 = Color(0xFFFFEEE2);
  static const Color accent90 = Color(0xFFFEDCC5);
  static const Color accent80 = Color(0xFFFFB781);
  static const Color accent60 = Color(0xFFDE7402);
  static const Color accent50 = Color(0xFFB85F01);
  static const Color accent40 = Color(0xFF934B01);
  static const Color accent20 = Color(0xFF4D2600);
  static const Color secAccent95 = Color(0xFFC4FBFF);
  static const Color secAccent90 = Color(0xFF72F5FF);
  static const Color secAccent80 = Color(0xFF4AD9E3);
  static const Color secAccent40 = Color(0xFF05696F);
  static const Color secAccent30 = Color(0xFF034F54);
  static const Color secAccent20 = Color(0xFF02363A);
  static const Color premium95 = Color(0xFFFFEFD5);
  static const Color premium90 = Color(0xFFFFDEA2);
  static const Color premium80 = Color(0xFFF3BF3A);
  static const Color premium35 = Color(0xFF684F01);
  static const Color premium25 = Color(0xFF4C3900);
  static const Color premium20 = Color(0xFF3E2E00);
  static const Color error95 = Color(0xFFFFEDEB);
  static const Color error90 = Color(0xFFFEDAD7);
  static const Color error80 = Color(0xFFFFB4AD);
  static const Color error50 = Color(0xFFE03140);
  static const Color error20 = Color(0xFF680012);
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color neutral95 = Color(0xFFF3F0ED);
  static const Color neutral90 = Color(0xFFE8E1DC);
  static const Color neutral80 = Color(0xFFCBC5C0);
  static const Color neutral70 = Color(0xFFB0AAA5);
  static const Color neutral60 = Color(0xFF95908B);
  static const Color neutral50 = Color(0xFF7B7671);
  static const Color neutral40 = Color(0xFF635D59);
  static const Color neutral30 = Color(0xFF4B4642);
  static const Color neutral25 = Color(0xFF3F3B36);
  static const Color neutral20 = Color(0xFF34302C);
  static const Color neutral15 = Color(0xFF282523);
  static const Color neutral10 = Color(0xFF1D1B19);
  static const Color neutral5 = Color(0xFF13100E);
  static const Color neutral0 = Color(0xFF000000);

  ColorScheme toColorScheme({bool isDark = false}) {
    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? accent80 : accent60,
      onPrimary: isDark ? accent20 : neutral100,
      primaryContainer: isDark ? accent20 : accent95,
      onPrimaryContainer: isDark ? accent90 : neutral10,
      secondary: isDark ? secAccent80 : secAccent40,
      onSecondary: isDark ? secAccent20 : neutral100,
      secondaryContainer: isDark ? secAccent20 : secAccent95,
      onSecondaryContainer: isDark ? secAccent90 : neutral10,
      tertiary: isDark ? premium80 : premium80,
      onTertiary: isDark ? premium20 : premium35,
      tertiaryContainer: isDark ? premium20 : premium95,
      onTertiaryContainer: isDark ? premium90 : neutral10,
      error: isDark ? error80 : error50,
      onError: isDark ? error20 : neutral100,
      errorContainer: isDark ? error20 : error95,
      onErrorContainer: isDark ? error90 : neutral10,
      surface: isDark ? neutral10 : neutral100,
      onSurface: isDark ? neutral90 : neutral10,
      surfaceContainerHighest: isDark ? neutral30 : neutral80,
      surfaceContainerHigh: isDark ? neutral20 : neutral95,
      surfaceContainer: isDark ? neutral10 : neutral100,
      surfaceContainerLow: isDark ? neutral10 : neutral100,
      surfaceContainerLowest: isDark ? neutral10 : neutral100,
      onSurfaceVariant: isDark ? neutral60 : neutral50,
      outline: isDark ? neutral20 : neutral95,
      outlineVariant: isDark ? neutral20 : neutral95,
      shadow: neutral0,
      scrim: isDark ? neutral0 : const Color(0x80000000),
      inverseSurface: isDark ? neutral100 : neutral0,
      onInverseSurface: isDark ? neutral10 : neutral100,
      inversePrimary: isDark ? accent40 : accent80,
      surfaceTint: isDark ? accent80 : accent60,
    );
  }

  ThemeData toThemeData({bool isDark = false}) {
    final ColorScheme colorScheme = toColorScheme(isDark: isDark);
    final TextTheme textTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;

    final theme = ThemeData.from(colorScheme: colorScheme, textTheme: textTheme).copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isDark ? accent80 : accent60,
        selectionColor: isDark ? accent20 : accent95,
      ),
    );

    return _applyHoverlessTheme(theme);
  }
}

class ContextAwarePalette {
  const ContextAwarePalette(this._context);

  final BuildContext _context;

  bool get _isDark => Theme.of(_context).brightness == Brightness.dark;

  Color get primaryContainer => _isDark ? CharPalette.accent20 : CharPalette.accent95;
  Color get onPrimary => _isDark ? CharPalette.accent20 : CharPalette.neutral100;
  Color get onPrimaryContainer => _isDark ? CharPalette.accent90 : CharPalette.neutral10;

  Color get secondaryContainer => _isDark ? CharPalette.secAccent20 : CharPalette.secAccent95;
  Color get onSecondary => _isDark ? CharPalette.secAccent20 : CharPalette.neutral100;
  Color get onSecondaryContainer => _isDark ? CharPalette.secAccent90 : CharPalette.neutral10;

  Color get errorContainer => _isDark ? CharPalette.error20 : CharPalette.error95;
  Color get onError => _isDark ? CharPalette.error20 : CharPalette.neutral100;
  Color get onErrorContainer => _isDark ? CharPalette.error90 : CharPalette.neutral10;

  Color get surfaceWhite => _isDark ? CharPalette.neutral5 : CharPalette.neutral100;
  Color get surfaceLightAccent => _isDark ? CharPalette.neutral25 : CharPalette.error95;
  Color get surfaceExtraLight => _isDark ? CharPalette.neutral20 : CharPalette.neutral95;
  Color get surfaceLight => _isDark ? CharPalette.neutral15 : CharPalette.neutral90;
  Color get surfaceMedium => CharPalette.neutral40;

  Color get surfaceFixedAccent => CharPalette.accent60;
  Color get surfaceFixedDarkAccent => CharPalette.accent50;
  Color get surfaceFixedWhite => CharPalette.neutral100;
  Color get surfaceFixedBlackBg => CharPalette.neutral0;

  Color get surfaceTranslucentWhite => _isDark ? CharPalette.neutral5 : CharPalette.neutral100;

  Color get surfaceTranslucentFixedGrey => CharPalette.neutral50;
  Color get surfaceTranslucentFixedWhite => CharPalette.neutral100;
  Color get surfaceTranslucentFixedBlack => CharPalette.neutral5;

  Color get textOnSurfacePrimary => _isDark ? CharPalette.neutral100 : CharPalette.neutral10;
  Color get textOnSurfaceDisabledLight => _isDark ? CharPalette.neutral30 : CharPalette.neutral70;
  Color get textOnSurfaceWhite => _isDark ? CharPalette.neutral10 : CharPalette.neutral100;
  Color get textOnSurfaceMediumGrey => _isDark ? CharPalette.neutral60 : CharPalette.neutral40;

  Color get textOnSurfaceSecondary => _isDark ? CharPalette.neutral60 : CharPalette.neutral50;
  Color get textOnSurfaceDarkPremium => _isDark ? CharPalette.premium20 : CharPalette.premium25;
  Color get textOnSurfaceDisabled => _isDark ? CharPalette.neutral60 : CharPalette.neutral70;

  Color get textOnSurfaceFixedWhite => CharPalette.neutral100;
  Color get textOnSurfaceFixedPrimary => CharPalette.neutral10;
  Color get textOnSurfaceFixedSecondary => CharPalette.neutral50;

  Color get iconOnSurfacePrimary => _isDark ? CharPalette.neutral100 : CharPalette.neutral10;
  Color get iconOnSurfaceAccent => _isDark ? CharPalette.accent100 : CharPalette.accent60;
  Color get iconOnSurfaceWhite => _isDark ? CharPalette.neutral15 : CharPalette.neutral100;

  Color get iconOnSurfaceFixedSecondary => CharPalette.neutral50;
  Color get iconOnSurfaceFixedAccent => CharPalette.accent60;
  Color get iconOnSurfaceFixedWhite => CharPalette.neutral100;
  Color get iconOnSurfaceFixedLightGrey => CharPalette.neutral70;
  Color get iconOnSurfaceFixedBlack => CharPalette.neutral0;

  Color get buttonDisabledLight => _isDark ? CharPalette.neutral10 : CharPalette.neutral95;

  Color get buttonTranslucentWhite30 => _isDark
      ? CharPalette.neutral0.withAlphaPercent(30)
      : CharPalette.neutral100.withAlphaPercent(30);
  Color get buttonTranslucentBlack30 => _isDark
      ? CharPalette.neutral100.withAlphaPercent(30)
      : CharPalette.neutral0.withAlphaPercent(30);

  Color get buttonFixedAccentDefault => CharPalette.accent60;

  Color get buttonFixedPremiumDefault => CharPalette.premium80;

  Color get buttonFixedSecAccentDefault => CharPalette.secAccent30;

  Color get buttonFixedWhiteDefault => CharPalette.neutral100;

  Color get buttonFixedPrimaryDefault => CharPalette.neutral5;

  Color get buttonPrimaryDefault => _isDark ? CharPalette.neutral100 : CharPalette.neutral5;

  Color get buttonSecondaryDefault => _isDark ? CharPalette.neutral25 : CharPalette.neutral95;

  Color get tagLightGrey => _isDark ? CharPalette.neutral15 : CharPalette.neutral95;

  Color get outlineDefault => _isDark ? CharPalette.neutral20 : CharPalette.neutral95;
  Color get outlineLight => _isDark ? CharPalette.neutral50 : CharPalette.neutral80;

  Color get outlineFixedDefault => CharPalette.neutral95;
  Color get outlineFixedAccent => CharPalette.accent60;
  Color get outlineFixedMedium => CharPalette.neutral60;

  ColorScheme toColorScheme() => CharPalette.instance.toColorScheme(isDark: _isDark);
  ThemeData toThemeData() => CharPalette.instance.toThemeData(isDark: _isDark);
}

ThemeData _applyHoverlessTheme(ThemeData theme) {
  return theme.copyWith(
    hoverColor: Colors.transparent,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentHoverOverlay()),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentHoverOverlay()),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentHoverOverlay()),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentHoverOverlay()),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentHoverOverlay()),
    ),
  );
}

WidgetStateProperty<Color?> _transparentHoverOverlay() {
  return WidgetStateProperty.all(Colors.transparent);
}
