import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: DefaultTextStyle(style: AppStyle.of(context).text.p1, child: child),
    );
  }
}
