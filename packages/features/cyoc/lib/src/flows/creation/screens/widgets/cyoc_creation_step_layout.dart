import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class CyocCreationStepLayout extends StatelessWidget {
  const CyocCreationStepLayout({
    required this.children,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    super.key,
  });

  final List<Widget> children;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: contentPadding + EdgeInsets.only(bottom: CharPadding.of(context).bottom),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
