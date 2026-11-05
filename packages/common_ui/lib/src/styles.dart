import 'package:flutter/material.dart';

import 'colors.dart';
import 'curves.dart';
import 'durations.dart';
import 'radii.dart';
import 'spacing.dart';

class AppStyle extends InheritedWidget {
  AppStyle({required super.child, super.key});

  late final text = AppTextStyles();
  late final curves = AppCurves();
  late final durations = AppDurations();
  late final spacing = AppSpacing.char;
  late final radii = AppRadii.char;

  CharPalette get rawPalette => CharPalette.instance;

  static AppStyle of(BuildContext context) {
    final appStyle = context.dependOnInheritedWidgetOfExactType<AppStyle>();
    assert(appStyle != null, 'No AppStyle found in context');
    return appStyle!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => oldWidget.key != key;
}

class AppStyleWithPalette extends AppStyle {
  AppStyleWithPalette._(this._context, this._baseStyle)
    : super(child: _baseStyle.child, key: _baseStyle.key);

  final BuildContext _context;
  final AppStyle _baseStyle;

  @override
  AppTextStyles get text => _baseStyle.text;

  @override
  AppCurves get curves => _baseStyle.curves;

  @override
  AppDurations get durations => _baseStyle.durations;

  @override
  AppSpacing get spacing => _baseStyle.spacing;

  @override
  AppRadii get radii => _baseStyle.radii;

  @override
  CharPalette get rawPalette => _baseStyle.rawPalette;

  ContextAwarePalette get palette => ContextAwarePalette(_context);
}

extension AppStyleExtensions on BuildContext {
  AppStyleWithPalette get appStyle => AppStyleWithPalette._(this, AppStyle.of(this));

  ContextAwarePalette get palette => ContextAwarePalette(this);
}

extension AppStylePaletteExtension on AppStyle {
  ContextAwarePalette palette(BuildContext context) => ContextAwarePalette(context);
}

class AppTextStyles {
  final TextStyle contentTextStyle = const TextStyle();
  final TextStyle bodyTextStyle = const TextStyle();

  late final TextStyle h1 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 76,
    textHeight: 64,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.03,
  );
  late final TextStyle h2 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 52,
    textHeight: 56,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.025,
  );
  late final TextStyle h3 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 44,
    textHeight: 48,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.022,
  );
  late final TextStyle h4 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 36,
    textHeight: 38,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.02,
  );
  late final TextStyle h5 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 28,
    textHeight: 30,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.018,
  );
  late final TextStyle h6 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 20,
    textHeight: 22,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.014,
  );
  late final TextStyle h7 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 18,
    textHeight: 20,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.012,
  );
  late final TextStyle h8 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 16,
    textHeight: 20,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.01,
  );
  late final TextStyle h9 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 14,
    textHeight: 18,
    fontWeight: _headingWeight,
    letterSpacingEm: -0.008,
  );
  late final TextStyle h10 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 12,
    textHeight: 12,
    fontWeight: _headingWeight,
  );
  late final TextStyle subtitle1 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 20,
    textHeight: 22,
    fontWeight: _subtitleWeight,
    letterSpacingEm: -0.012,
  );
  late final TextStyle subtitle2 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 16,
    textHeight: 20,
    fontWeight: _subtitleWeight,
    letterSpacingEm: -0.008,
  );
  late final TextStyle subtitle3 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 14,
    textHeight: 18,
    fontWeight: _subtitleWeight,
    letterSpacingEm: -0.006,
  );
  late final TextStyle subtitle4 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 12,
    textHeight: 16,
    fontWeight: _subtitleWeight,
  );
  late final TextStyle subtitle5 = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 10,
    textHeight: 14,
    fontWeight: _subtitleWeight,
  );
  late final TextStyle p1 = _createTextStyle(
    parentStyle: bodyTextStyle,
    textSize: 16,
    textHeight: 20,
    fontWeight: _bodyTextWeight,
    letterSpacingEm: -0.006,
  );
  late final TextStyle p2 = _createTextStyle(
    parentStyle: bodyTextStyle,
    textSize: 14,
    textHeight: 18,
    fontWeight: _bodyTextWeight,
    letterSpacingEm: -0.004,
  );
  late final TextStyle caption1 = _createTextStyle(
    parentStyle: bodyTextStyle,
    textSize: 12,
    textHeight: 16,
    fontWeight: _bodyTextWeight,
  );
  late final TextStyle caption2 = _createTextStyle(
    parentStyle: bodyTextStyle,
    textSize: 10,
    textHeight: 12,
    fontWeight: _bodyTextWeight,
  );
  late final TextStyle overLine = _createTextStyle(
    parentStyle: contentTextStyle,
    textSize: 10,
    textHeight: 13,
    fontWeight: FontWeight.w600,
    letterSpacingEm: 0.06,
  );

  static const FontWeight _headingWeight = FontWeight.w800;
  static const FontWeight _subtitleWeight = FontWeight.w600;
  static const FontWeight _bodyTextWeight = FontWeight.w500;

  TextStyle _createTextStyle({
    required TextStyle parentStyle,
    required FontWeight fontWeight,
    required int textSize,
    required int textHeight,
    double letterSpacingEm = 0,
  }) {
    return parentStyle.copyWith(
      fontSize: textSize.toDouble(),
      height: textHeight / textSize,
      fontWeight: fontWeight,
      letterSpacing: textSize * letterSpacingEm,
    );
  }
}

extension TextStyleWeightVariants on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w500);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w600);
  TextStyle get black => copyWith(fontWeight: FontWeight.w800);
}
