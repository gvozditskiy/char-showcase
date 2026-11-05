import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'widgets/char_padding.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({required this.body, super.key});

  final Widget body;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return CharPadding(
      EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: AppTheme(child: Center(child: widget.body)),
      ),
    );
  }
}
