import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../constants/profile_constants.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
    this.description,
    this.spacing = ProfileConstants.spacing20,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final appStyle = context.appStyle;
    final palette = appStyle.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: appStyle.text.h8.copyWith(color: palette.textOnSurfacePrimary)),
        if (description != null) ...[
          const SizedBox(height: ProfileConstants.spacing5),
          Text(description!, style: appStyle.text.p2.copyWith(color: palette.textOnSurfacePrimary)),
        ],
        const SizedBox(height: ProfileConstants.spacing16),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceWhite,
            borderRadius: BorderRadius.circular(ProfileConstants.spacing20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ProfileConstants.spacing20),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) SizedBox(height: spacing),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticsIdentifier,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticsIdentifier;

  @override
  Widget build(BuildContext context) {
    final appStyle = context.appStyle;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            style: appStyle.text.h8.copyWith(color: appStyle.palette.textOnSurfacePrimary),
          ),
        ),
        const SizedBox(width: ProfileConstants.spacing20),
        ToggleSwitch(value: value, onChanged: onChanged, semanticsIdentifier: semanticsIdentifier),
      ],
    );
  }
}
