import 'dart:ui' show lerpDouble;

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import 'cyoc_section_header.dart';

typedef CyocPagedTileBuilder<T> =
    Widget Function(
      BuildContext context,
      T option, {
      required bool selected,
      required double scale,
      required VoidCallback onTap,
    });

class CyocPagedSelector<T> extends StatefulWidget {
  const CyocPagedSelector({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.tileWidth,
    required this.tileHeight,
    required this.tileBuilder,
    required this.grows,
    this.itemSpacing,
    this.titleGap,
    super.key,
  });

  final String title;
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final double tileWidth;
  final double tileHeight;
  final CyocPagedTileBuilder<T> tileBuilder;

  final bool grows;

  final double? itemSpacing;
  final double? titleGap;

  static const unselectedScale = 0.9;

  @override
  State<CyocPagedSelector<T>> createState() => _CyocPagedSelectorState<T>();
}

class _CyocPagedSelectorState<T> extends State<CyocPagedSelector<T>> {
  static const _cyclesBeforeInitialPage = 5000;

  PageController? _controller;
  double _viewportFraction = 1;
  late int _page = _initialPage;

  int get _optionsCount => widget.options.length;

  int get _selectedIndex {
    final index = widget.options.indexWhere((option) => option == widget.selected);
    return index < 0 ? 0 : index;
  }

  int get _initialPage =>
      _optionsCount == 0 ? 0 : _cyclesBeforeInitialPage * _optionsCount + _selectedIndex;

  int _realIndexOf(int page) => _optionsCount == 0 ? 0 : page % _optionsCount;

  @override
  void didUpdateWidget(CyocPagedSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetIndex = _selectedIndex;
    if (_realIndexOf(_page) == targetIndex) {
      return;
    }
    final cycle = _optionsCount == 0 ? 0 : _page ~/ _optionsCount;
    _page = cycle * _optionsCount + targetIndex;
    _controller?.jumpToPage(_page);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final spacing = widget.itemSpacing ?? style.spacing.space2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CyocSectionHeader(
          title: widget.title,
          verticalPadding: CyocSectionHeader.carouselVerticalPadding,
        ),
        SizedBox(height: widget.titleGap ?? style.spacing.space1),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SizedBox(width: constraints.maxWidth, height: widget.tileHeight),
                Positioned.fill(child: _buildPages(context, constraints, spacing)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPages(BuildContext context, BoxConstraints constraints, double spacing) {
    if (_optionsCount == 0) {
      return const SizedBox.shrink();
    }
    final controller = _resolveController(constraints.maxWidth, spacing);
    return PageView.builder(
      controller: controller,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final option = widget.options[_realIndexOf(index)];
        final selected = option == widget.selected;
        if (!widget.grows) {
          return Center(
            child: widget.tileBuilder(
              context,
              option,
              selected: selected,
              scale: 1,
              onTap: () => _animateTo(index),
            ),
          );
        }
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final page = controller.hasClients
                ? (controller.page ?? _page.toDouble())
                : _page.toDouble();
            final distanceFromCenter = (index - page).abs().clamp(0.0, 1.0);
            final scale = lerpDouble(1, CyocPagedSelector.unselectedScale, distanceFromCenter)!;
            return Center(
              child: widget.tileBuilder(
                context,
                option,
                selected: selected,
                scale: scale,
                onTap: () => _animateTo(index),
              ),
            );
          },
        );
      },
    );
  }

  PageController _resolveController(double viewportWidth, double spacing) {
    final pageExtent = widget.tileWidth + spacing;
    final fraction = viewportWidth <= 0 ? 1.0 : (pageExtent / viewportWidth).clamp(0.1, 1.0);
    if (_controller == null || fraction != _viewportFraction) {
      _controller?.dispose();
      _viewportFraction = fraction;
      _controller = PageController(initialPage: _page, viewportFraction: fraction);
    }
    return _controller!;
  }

  void _onPageChanged(int page) {
    if (page == _page) {
      return;
    }
    _page = page;
    widget.onChanged(widget.options[_realIndexOf(page)]);
  }

  void _animateTo(int index) {
    _controller?.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: AppCurves.easeOut,
    );
  }
}
