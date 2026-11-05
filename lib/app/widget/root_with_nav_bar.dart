import 'dart:math';

import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/nab_bar_root/nav_bar_root_cubit.dart';
import 'floating_navigation_bar.dart';

class RootWithNavBar extends StatefulWidget {
  const RootWithNavBar({required this.body, required this.navBarBuilder, super.key});

  final Widget body;
  final Widget? Function({
    required List<NavBarItem> navBarItems,
    required ValueChanged<NavBarItem> onSelected,
  })
  navBarBuilder;

  @override
  State<RootWithNavBar> createState() => _RootWithNavBarState();
}

class _RootWithNavBarState extends State<RootWithNavBar> {
  late final NavBarRootCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<NavBarRootCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarRootCubit, NavBarRootState>(
      bloc: _cubit,
      builder: (context, state) {
        final navBarWidget = widget.navBarBuilder(
          navBarItems: state.navBarItems,
          onSelected: _cubit.onNavBarItemSelected,
        );

        return RootNavBarContextProvider(
          context,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxSize = MediaQuery.sizeOf(context);
              final width = max(0, min(constraints.maxWidth, maxSize.width)).toDouble();
              final height = max(0, min(constraints.maxHeight, maxSize.height)).toDouble();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const CharBackground(),
                  Positioned.fill(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(width, height)),
                      child: CharPadding(
                        CharPadding.of(context, includeMedia: false) +
                            EdgeInsets.only(
                              bottom: navBarWidget == null
                                  ? 0
                                  : FloatingNavigationBar.reservedHeight,
                            ),
                        child: widget.body,
                      ),
                    ),
                  ),
                  if (navBarWidget != null)
                    Positioned(bottom: 0, left: 0, right: 0, child: navBarWidget),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
