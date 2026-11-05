import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import 'widgets/cyoc_loading_progress_footer.dart';

class CyocGenerationScreen extends StatelessWidget {
  const CyocGenerationScreen({super.key});

  static const double _photoBoxWidth = 295;
  static const double _photoBoxHeight = 472;
  static const double _photoBoxRadius = 35;
  static const double _titleBlockHeight = 60;
  static const double _photoToTextGap = 8;
  static const double _loaderSize = 64;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;

    return AutomationSemantics(
      identifier: 'cyoc_creation_generation_screen',
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _photoBoxWidth),
                child: AspectRatio(
                  aspectRatio: _photoBoxWidth / _photoBoxHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_photoBoxRadius),
                    child: ColoredBox(
                      color: palette.surfaceExtraLight,
                      child: const Center(
                        child: CharLoader(dimension: _loaderSize, dark: true, fixedColor: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: style.spacing.space5,
              right: style.spacing.space5,
              bottom: CharPadding.of(context).bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: _photoToTextGap),
                CyocLoadingProgressFooter(
                  titleColor: palette.textOnSurfacePrimary,
                  subtitleColor: palette.textOnSurfaceSecondary,
                  titleBoxHeight: _titleBlockHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
