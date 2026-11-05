import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class CyocSuggestButton extends StatelessWidget {
  const CyocSuggestButton({required this.onClick, super.key, this.semanticsIdentifier});

  final VoidCallback onClick;
  final String? semanticsIdentifier;

  static const double _iconSide = 24;

  @override
  Widget build(BuildContext context) {
    return ClickDetector(
      semanticsIdentifier: semanticsIdentifier,
      onClick: onClick,
      child: Icon(
        Icons.auto_fix_high_rounded,
        size: _iconSide,
        color: context.palette.iconOnSurfaceFixedAccent,
      ),
    );
  }
}
