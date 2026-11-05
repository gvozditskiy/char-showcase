import 'dart:async';

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class CyocFakeProgressBar extends StatefulWidget {
  const CyocFakeProgressBar({
    required this.averageGenerationTime,
    required this.finished,
    this.progressColor,
    this.backgroundColor,
    super.key,
  });

  final Duration averageGenerationTime;
  final bool finished;
  final Color? progressColor;
  final Color? backgroundColor;

  static const int _steps = 5;

  @override
  State<CyocFakeProgressBar> createState() => _CyocFakeProgressBarState();
}

class _CyocFakeProgressBarState extends State<CyocFakeProgressBar> {
  StreamSubscription<double>? _subscription;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _subscription = _progressStream(widget.averageGenerationTime).listen((value) {
      setState(() => _progress = value);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CharLinearProgressBar(
      progress: widget.finished ? 1 : _progress,
      progressColor: widget.progressColor,
      backgroundColor: widget.backgroundColor,
    );
  }

  static Stream<double> _progressStream(Duration total) async* {
    final stepDuration = total ~/ CyocFakeProgressBar._steps;
    for (var step = 0; step < CyocFakeProgressBar._steps; step++) {
      yield (step + 1) / (CyocFakeProgressBar._steps + 1);
      await Future<void>.delayed(stepDuration);
    }
  }
}
