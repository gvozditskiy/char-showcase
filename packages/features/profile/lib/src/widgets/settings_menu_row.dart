import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/profile_constants.dart';

class SettingsMenuRow extends StatelessWidget {
  const SettingsMenuRow({
    required this.label,
    required this.iconAssetPath,
    required this.onPressed,
    this.semanticsIdentifier,
    super.key,
  });

  final String label;
  final String iconAssetPath;
  final VoidCallback onPressed;
  final String? semanticsIdentifier;

  @override
  Widget build(BuildContext context) {
    final theme = ThemedButtonTheme.white(context).copyWith(borderRadius: 25);
    return ThemedButton(
      onPressed: onPressed,
      size: ThemedButtonSize.xl,
      theme: theme,
      semanticsIdentifier: semanticsIdentifier,
      child: Row(
        children: [
          SvgPicture.asset(
            iconAssetPath,
            package: ProfileConstants.packageName,
            width: ProfileConstants.icon24,
            height: ProfileConstants.icon24,
            colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: ProfileConstants.spacing10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appStyle.text.h8.copyWith(color: theme.textColor),
            ),
          ),
          const SizedBox(width: ProfileConstants.spacing10),
          SvgPicture.asset(
            ProfileConstants.icArrowRight,
            package: ProfileConstants.packageName,
            width: ProfileConstants.icon24,
            height: ProfileConstants.icon24,
          ),
        ],
      ),
    );
  }
}
