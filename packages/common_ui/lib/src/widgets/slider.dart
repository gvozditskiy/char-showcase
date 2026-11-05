import 'dart:math';

import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';
import '../styles.dart';

class CharSlider extends StatefulWidget {
  const CharSlider({
    required this.max,
    required this.value,
    required this.divisions,
    required this.min,
    required this.onChanged,
    required this.onDragEnd,
    required this.onDragStart,
    required this.onDragCancel,
    super.key,
    this.height = defaultHeight,
    this.trackHeight,
    this.thumbSize,
    this.fillFromStart = false,
    this.thumbStyle = CharSliderThumbStyle.white,
  }) : assert((max - min + 1) % divisions == 0, 'one div should be int');

  static const double defaultHeight = 34;
  static const double _accentThumbBlurRadius = 4.5;
  static const double _accentThumbShadowOffsetY = 1.5;
  static const int _accentThumbShadowAlphaPercent = 15;

  final int min;
  final int max;
  final double value;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<int> onDragEnd;
  final VoidCallback onDragStart;
  final VoidCallback onDragCancel;
  final double height;
  final double? trackHeight;
  final double? thumbSize;
  final bool fillFromStart;
  final CharSliderThumbStyle thumbStyle;

  @override
  State<CharSlider> createState() => CharSliderState();
}

enum CharSliderThumbStyle { white, accentElevated }

class CharSliderState extends State<CharSlider> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.biggest.width;
          final boxHeight = constraints.biggest.height;
          final thumbSize = widget.thumbSize ?? boxHeight;
          final trackHeight = widget.trackHeight ?? boxHeight;
          final trackTop = (boxHeight - trackHeight) / 2;
          final thumbTop = (boxHeight - thumbSize) / 2;
          final valuePercents = (widget.value - widget.min) / ((widget.max - widget.min) / 100);
          final thumbLeft = (width - thumbSize) / 100 * valuePercents;
          return GestureDetector(
            onHorizontalDragDown: (details) => _reportValueAt(details.localPosition.dx, width),
            onHorizontalDragUpdate: (details) {
              if (!_isDragging) {
                setState(() {
                  _isDragging = true;
                });
              }
              _reportValueAt(details.localPosition.dx, width);
            },
            onHorizontalDragEnd: (details) {
              setState(() {
                _isDragging = false;
              });
              widget.onDragEnd(_snappedToDivision(widget.value));
            },
            onTapUp: (details) {
              setState(() {
                _isDragging = false;
              });
              widget.onDragEnd(_snappedToDivision(widget.value));
            },
            onHorizontalDragStart: (_) {
              widget.onDragStart();
            },
            onHorizontalDragCancel: () {
              setState(() {
                _isDragging = false;
              });
              widget.onDragCancel();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: trackTop,
                  height: trackHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(trackHeight),
                      color: palette.surfaceExtraLight,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _isDragging ? Duration.zero : const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  left: widget.fillFromStart
                      ? 0
                      : (thumbLeft + .5 * thumbSize < width / 2
                            ? thumbLeft
                            : width / 2 - thumbSize / 2),
                  top: trackTop,
                  height: trackHeight,
                  width: widget.fillFromStart
                      ? thumbLeft + thumbSize / 2
                      : max(
                          thumbSize,
                          thumbLeft + .5 * thumbSize < width / 2
                              ? width / 2 - thumbLeft + thumbSize / 2
                              : thumbLeft - width / 2 + 1.5 * thumbSize,
                        ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(trackHeight),
                        right: Radius.circular(trackHeight),
                      ),
                      color: palette.surfaceFixedAccent,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _isDragging ? Duration.zero : const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  left: thumbLeft,
                  top: thumbTop,
                  height: thumbSize,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: switch (widget.thumbStyle) {
                      CharSliderThumbStyle.white => Padding(
                        padding: const EdgeInsets.all(2),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(thumbSize - 2),
                            color: palette.surfaceFixedWhite,
                          ),
                        ),
                      ),
                      CharSliderThumbStyle.accentElevated => DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.surfaceFixedAccent,
                          boxShadow: [
                            BoxShadow(
                              color: palette.surfaceTranslucentFixedBlack.withAlphaPercent(
                                CharSlider._accentThumbShadowAlphaPercent,
                              ),
                              blurRadius: CharSlider._accentThumbBlurRadius,
                              offset: const Offset(0, CharSlider._accentThumbShadowOffsetY),
                            ),
                          ],
                        ),
                      ),
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _reportValueAt(double dx, double width) {
    final valueAtPosition = widget.min + dx / (width / 100) * ((widget.max - widget.min) / 100);
    widget.onChanged(valueAtPosition.clamp(widget.min.toDouble(), widget.max.toDouble()));
  }

  int _snappedToDivision(double value) {
    final divisionStep = (widget.max - widget.min) / (widget.divisions - 1);
    final divisionIndex = ((value - widget.min) / divisionStep).round();
    return (widget.min + divisionIndex * divisionStep).round();
  }
}
