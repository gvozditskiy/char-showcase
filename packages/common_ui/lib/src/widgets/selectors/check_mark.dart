import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../styles.dart';

class CheckMark extends StatelessWidget {
  const CheckMark({
    required this.selected,
    super.key,
    this.toggleable = false,
    this.overImg = false,
    this.bgColor,
    this.size = 30,
    this.tickSize,
    this.unselectedBorderColor,
  });

  final bool selected;
  final bool toggleable;
  final bool overImg;
  final Color? bgColor;
  final double size;
  final double? tickSize;
  final Color? unselectedBorderColor;

  @override
  Widget build(BuildContext context) {
    final AppStyle(durations: durations) = context.appStyle;
    return Stack(
      children: [
        if (overImg)
          _OverImgUnselected(size: size, borderColor: unselectedBorderColor)
        else
          _NotOverImgUnselected(size: size, borderColor: unselectedBorderColor),
        if (selected)
          _Selected(
            color: bgColor,
            size: size,
            tickSize: tickSize,
          ).animate().fadeIn(duration: durations.radio),
      ],
    );
  }
}

class _NotOverImgUnselected extends StatelessWidget {
  const _NotOverImgUnselected({required this.size, this.borderColor});
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      key: const ValueKey('unselected'),
      width: size,
      height: size,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? palette.outlineLight),
        ),
      ),
    );
  }
}

class _Selected extends StatelessWidget {
  const _Selected({this.color, this.size = 30, this.tickSize});

  final Color? color;
  final double size;
  final double? tickSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tick = tickSize;
    return SizedBox(
      key: const ValueKey('selected'),
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? palette.surfaceFixedAccent,
        ),
        child: Center(
          child: tick != null
              ? Icon(Icons.check_rounded, size: tick, color: palette.iconOnSurfaceFixedWhite)
              : Padding(
                  padding: EdgeInsets.all(context.appStyle.spacing.space1),
                  child: FittedBox(
                    child: Icon(Icons.check_rounded, color: palette.iconOnSurfaceFixedWhite),
                  ),
                ),
        ),
      ),
    );
  }
}

class _OverImgUnselected extends StatelessWidget {
  const _OverImgUnselected({required this.size, this.borderColor});
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      key: const ValueKey('unselected'),
      width: size,
      height: size,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? palette.outlineFixedDefault),
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
