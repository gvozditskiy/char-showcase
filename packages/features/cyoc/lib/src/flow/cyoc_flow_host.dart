import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/segmented_progress_indicator.dart';
import 'cyoc_flow_controller.dart';
import 'cyoc_flow_step.dart';

class CyocFlowHost extends StatelessWidget {
  const CyocFlowHost({
    required this.controller,
    required this.bodyFactory,
    required this.footerFactory,
    this.title,
    this.onExit,
    this.onBack,
    super.key,
  });

  final Cubit<CyocFlowState> controller;
  final Widget Function(BuildContext context, CyocFlowStep step) bodyFactory;
  final PreferredSizeWidget? Function(BuildContext context, CyocFlowStep step) footerFactory;
  final String? title;
  final VoidCallback? onExit;
  final VoidCallback? onBack;

  static const double _toolbarRowHeight = 48;
  static const double _toolbarButtonSize = 40;
  static const double _toolbarIconSize = 24;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Cubit<CyocFlowState>, CyocFlowState>(
      bloc: controller,
      builder: (context, state) {
        final footer = footerFactory(context, state.current);
        final bottomInset =
            MediaQuery.paddingOf(context).bottom +
            MediaQuery.viewInsetsOf(context).bottom +
            _CyocFooterChrome._maxPlatformFooterBottomPadding;
        return CharPopScope(
          interceptBack: true,
          onPopInvoked: (systemPopBlocked, _) {
            if (systemPopBlocked) {
              _handleBack();
            }
          },
          child: PageScaffold(
            toolbar: _buildToolbar(context, state),
            floatingFooterPadding: EdgeInsets.zero,
            floatingFooter: footer == null
                ? null
                : _CyocFooterChrome(
                    key: ValueKey<String>(state.current.key),
                    bottomInset: bottomInset,
                    child: footer,
                  ),
            builder: (context, kbOpened) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children: [...previousChildren, if (currentChild != null) currentChild],
                ),
                child: KeyedSubtree(
                  key: ValueKey<String>(state.current.key),
                  child: bodyFactory(context, state.current),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleBack() {
    final goBack = onBack;
    if (goBack != null && _canGoBack(controller.state)) {
      goBack();
      return;
    }
    onExit?.call();
  }

  bool _canGoBack(CyocFlowState state) => state.canGoBack && state.current.allowsBack;

  Widget? _buildBackButton(BuildContext context, CyocFlowState state) {
    if (!state.current.allowsBack) {
      return null;
    }
    return CharIconButton(
      icon: Icons.arrow_back_ios_new_rounded,
      side: _toolbarButtonSize,
      iconSide: _toolbarIconSize,
      hasCircularBackground: true,
      hasShadow: false,
      color: context.palette.surfaceExtraLight,
      colorFilter: context.palette.iconOnSurfacePrimary,
      onTap: _handleBack,
      semanticsIdentifier: 'cyoc_creation_back_button',
    );
  }

  CharToolbar _buildToolbar(BuildContext context, CyocFlowState state) {
    final backButton = _buildBackButton(context, state);
    return CharToolbar(
      height: _toolbarRowHeight,
      leadingActions: [?backButton],
      trailingActions: [
        CharIconButton(
          icon: Icons.close_rounded,
          side: _toolbarButtonSize,
          iconSide: _toolbarIconSize,
          hasCircularBackground: true,
          hasShadow: false,
          color: context.palette.surfaceExtraLight,
          colorFilter: context.palette.iconOnSurfacePrimary,
          onTap: onExit,
          semanticsIdentifier: 'cyoc_flow_close_button',
        ),
      ],
      bottom: _CyocToolbarCaption(
        title: title,
        step: state.progressIndex,
        total: state.progressTotal,
        showProgress: state.hasProgress,
      ),
    );
  }
}

class _CyocFooterChrome extends StatelessWidget implements PreferredSizeWidget {
  const _CyocFooterChrome({required this.child, required this.bottomInset, super.key});

  final PreferredSizeWidget child;
  final double bottomInset;

  static const double _fadeHeight = 40;
  static const int _fadeEndAlphaPercent = 90;
  static const double _horizontalMargin = 20;

  static const double _maxPlatformFooterBottomPadding = 15;

  @override
  Size get preferredSize => Size.fromHeight(_fadeHeight + child.preferredSize.height + bottomInset);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(left: 0, right: 0, top: 0, bottom: -bottomInset, child: const _CyocFooterMask()),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: _fadeHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
              child: child,
            ),
          ],
        ),
      ],
    );
  }
}

class _CyocFooterMask extends StatelessWidget {
  const _CyocFooterMask();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _CyocFooterChrome._fadeHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  palette.surfaceTranslucentWhite.withAlphaPercent(0),
                  palette.surfaceTranslucentWhite.withAlphaPercent(
                    _CyocFooterChrome._fadeEndAlphaPercent,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  palette.surfaceTranslucentWhite.withAlphaPercent(
                    _CyocFooterChrome._fadeEndAlphaPercent,
                  ),
                  palette.surfaceTranslucentWhite,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CyocToolbarCaption extends StatelessWidget implements PreferredSizeWidget {
  const _CyocToolbarCaption({
    required this.title,
    required this.step,
    required this.total,
    required this.showProgress,
  });

  final String? title;
  final int step;
  final int total;
  final bool showProgress;

  bool get _hasProgressBar => showProgress && total > 1;

  static const double _titleHeight = 22;
  static const double _progressHeight = 4;
  static const double _gap = 16;
  static const double _bottomPadding = 8;
  static const double _sideMargin = 20;

  @override
  Size get preferredSize {
    var height = _bottomPadding;
    if (title != null) {
      height += _gap + _titleHeight;
    }
    if (_hasProgressBar) {
      height += _gap + _progressHeight;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final titleText = title;
    return Padding(
      padding: const EdgeInsets.only(bottom: _bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleText != null) ...[
            const SizedBox(height: _gap),
            SizedBox(
              height: _titleHeight,
              child: Text(
                titleText,
                textAlign: TextAlign.center,
                style: style.text.h6.copyWith(color: style.palette.textOnSurfacePrimary),
              ),
            ),
          ],
          if (_hasProgressBar) ...[
            const SizedBox(height: _gap),
            SegmentedProgressIndicator(
              step: step,
              total: total,
              width: MediaQuery.sizeOf(context).width - _sideMargin * 2,
            ),
          ],
        ],
      ),
    );
  }
}
