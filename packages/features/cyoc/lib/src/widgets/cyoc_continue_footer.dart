import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class CyocContinueFooter extends StatelessWidget implements PreferredSizeWidget {
  const CyocContinueFooter({
    required this.onContinue,
    this.semanticsIdentifier = 'cyoc_creation_continue_button',
    super.key,
  });

  final VoidCallback onContinue;
  final String semanticsIdentifier;

  @override
  Size get preferredSize => Size.fromHeight(ThemedButtonSize.m.height);

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return ThemedButton(
      text: strings.continueButtonTitle,
      size: ThemedButtonSize.m,
      theme: ThemedButtonTheme.primary(context),
      semanticsIdentifier: semanticsIdentifier,
      onPressed: onContinue,
    );
  }
}
