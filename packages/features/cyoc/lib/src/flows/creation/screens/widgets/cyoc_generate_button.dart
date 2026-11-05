import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../cyoc_creation_cubit.dart';

class CyocGenerateFooterButton extends StatelessWidget {
  const CyocGenerateFooterButton({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ThemedButton(
      text: context.l10n.cyocCreationCreateMyAi,
      size: ThemedButtonSize.m,
      theme: ThemedButtonTheme.primary(context),
      semanticsIdentifier: 'cyoc_creation_generate_button',
      onPressed: cubit.generate,
    );
  }
}
