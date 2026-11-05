import 'dart:async';

import 'package:flutter/widgets.dart';

import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';
import 'survey_screen_factory.dart';

class FlowHostController<T extends SurveyScreenModel> {
  final _screenKeyController = StreamController<String>.broadcast();
  String? _currentKey;
  bool _isClosed = false;

  Stream<String> get screenKeyStream => _screenKeyController.stream;
  String? get currentKey => _currentKey;

  void setInitialKey(String key) {
    if (_currentKey != null || _isClosed) {
      return;
    }
    _setKey(key);
  }

  void goToKey(String key) {
    _setKey(key);
  }

  void dispose() {
    _isClosed = true;
    unawaited(_screenKeyController.close());
  }

  void _setKey(String key) {
    if (_isClosed || _currentKey == key) {
      return;
    }
    _currentKey = key;
    _screenKeyController.add(key);
  }
}

class FlowHost<T extends SurveyScreenModel> extends StatefulWidget {
  const FlowHost({
    required this.controller,
    required this.config,
    required this.screenFactory,
    super.key,
  });

  final FlowHostController<T> controller;
  final SurveyFlowConfig<T> config;
  final SurveyScreenFactory<T> screenFactory;

  @override
  State<FlowHost<T>> createState() => _FlowHostState<T>();
}

class _FlowHostState<T extends SurveyScreenModel> extends State<FlowHost<T>> {
  @override
  void initState() {
    super.initState();
    _ensureInitialKey();
  }

  @override
  void didUpdateWidget(covariant FlowHost<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config || oldWidget.controller != widget.controller) {
      _ensureInitialKey(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = widget.config.screens;
    if (screens.isEmpty) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<String>(
      stream: widget.controller.screenKeyStream,
      initialData: widget.controller.currentKey ?? screens.first.key,
      builder: (context, snapshot) {
        final screenKey = snapshot.data ?? screens.first.key;
        final screenModel = screens.firstWhere(
          (screen) => screen.key == screenKey,
          orElse: () => screens.first,
        );
        return KeyedSubtree(
          key: ValueKey<String>(screenModel.key),
          child: widget.screenFactory(context, screenModel, widget.config),
        );
      },
    );
  }

  void _ensureInitialKey({bool force = false}) {
    final screens = widget.config.screens;
    if (screens.isEmpty) {
      return;
    }
    final currentKey = widget.controller.currentKey;
    final hasCurrent = currentKey != null && screens.any((screen) => screen.key == currentKey);
    if (force || !hasCurrent) {
      final nextKey = screens.first.key;
      if (currentKey == null) {
        widget.controller.setInitialKey(nextKey);
      } else {
        widget.controller.goToKey(nextKey);
      }
    }
  }
}
