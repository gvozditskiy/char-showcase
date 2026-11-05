import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

const _height = 4.0;

class SegmentedProgressIndicator extends StatelessWidget {
  const SegmentedProgressIndicator({
    required this.step,
    required this.total,
    required this.width,
    super.key,
  });
  final int step;
  final int total;
  final double width;

  static const _innerPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    if (total <= 1) {
      return const SizedBox.shrink();
    }

    final items = <Widget>[];
    for (var i = 1; i <= total; i++) {
      items.add(_IndicatorItem(highlighted: i <= step));
      if (i <= total - 1) {
        items.add(const SizedBox(width: _innerPadding));
      }
    }
    return SizedBox(
      width: width,
      height: _height,
      child: IgnorePointer(child: Row(children: items)),
    );
  }
}

class _IndicatorItem extends StatelessWidget {
  const _IndicatorItem({required this.highlighted});
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: SizedBox(
        height: _height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: highlighted ? palette.surfaceFixedAccent : palette.surfaceExtraLight,
          ),
        ),
      ),
    );
  }
}
