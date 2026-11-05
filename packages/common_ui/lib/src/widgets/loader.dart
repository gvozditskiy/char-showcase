import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../extensions/color_extensions.dart';
import '../styles.dart';

class CharLoader extends StatelessWidget {
  const CharLoader({
    super.key,
    this.dimension = 32,
    this.dark = false,
    this.fixedColor = true,
    this.color,
  });

  final double? dimension;
  final bool dark;
  final bool fixedColor;
  final Color? color;
  static const String _loadSmallAssetName = 'lib/assets/images/ic_loader_small.webp';
  static const String _loaderLargeAssetName = 'lib/assets/images/ic_loader_large.webp';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fixedLoaderColor =
        color ??
        (dark
            ? palette.iconOnSurfaceFixedBlack.withAlphaPercent(15)
            : palette.iconOnSurfaceFixedWhite.withAlphaPercent(70));
    final loaderColor =
        color ??
        (dark
            ? palette.iconOnSurfacePrimary.withAlphaPercent(15)
            : palette.iconOnSurfaceWhite.withAlphaPercent(70));
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: dimension, height: dimension),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Image.asset(
                constraints.maxHeight > 42 ? _loaderLargeAssetName : _loadSmallAssetName,
                package: 'common_ui',
                color: fixedColor ? fixedLoaderColor : loaderColor,
                fit: BoxFit.fill,
              )
              .animate(onComplete: (controller) => controller.repeat())
              .rotate(duration: const Duration(seconds: 1));
        },
      ),
    );
  }
}
