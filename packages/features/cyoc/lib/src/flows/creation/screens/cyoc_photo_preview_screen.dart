import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../cyoc_creation_cubit.dart';

class CyocPhotoPreviewScreen extends StatelessWidget {
  const CyocPhotoPreviewScreen({required this.cubit, super.key});

  static const double _photoBoxWidth = 295;
  static const double _photoBoxHeight = 472;
  static const double _photoBoxRadius = 35;
  static const double _photoTopGap = 20;

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AutomationSemantics(
      identifier: 'cyoc_creation_photo_preview_screen',
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        builder: (context, state) {
          final avatarUrl = state.result?.avatarUrl;
          return Padding(
            padding: EdgeInsets.only(top: _photoTopGap, bottom: CharPadding.of(context).bottom),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _photoBoxWidth),
                child: AspectRatio(
                  aspectRatio: _photoBoxWidth / _photoBoxHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_photoBoxRadius),
                    child: avatarUrl == null
                        ? const SizedBox.expand()
                        : Image.asset(avatarUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CyocPhotoPreviewButtons extends StatelessWidget {
  const CyocPhotoPreviewButtons({required this.cubit, super.key});

  static const double _buttonGap = 4;
  static const double _regenerateIconSide = 24;

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Row(
      children: [
        CharIconButton(
          icon: Icons.refresh_rounded,
          size: CharIconButtonSize.medium,
          iconSide: _regenerateIconSide,
          hasCircularBackground: true,
          hasShadow: false,
          color: context.palette.buttonSecondaryDefault,
          colorFilter: context.palette.iconOnSurfacePrimary,
          semanticsIdentifier: 'cyoc_creation_regenerate_button',
          onTap: cubit.regenerate,
        ),
        const SizedBox(width: _buttonGap),
        Expanded(
          child: ThemedButton(
            text: strings.continueButtonTitle,
            size: ThemedButtonSize.m,
            theme: ThemedButtonTheme.primary(context),
            semanticsIdentifier: 'cyoc_creation_preview_continue_button',
            onPressed: cubit.continueFromResult,
          ),
        ),
      ],
    );
  }
}
