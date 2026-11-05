import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

sealed class TransitionType extends Equatable {
  const TransitionType({
    this.transitionDuration = const Duration(milliseconds: 400),
    this.reverseTransitionDuration = const Duration(milliseconds: 400),
    this.curve,
  });

  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve? curve;

  @override
  List<Object?> get props => [transitionDuration, reverseTransitionDuration];
}

class TransitionTypeNone extends TransitionType {
  const TransitionTypeNone();
}

class TransitionTypeFade extends TransitionType {
  const TransitionTypeFade({
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.curve,
  });
}

class TransitionTypeFadeScale extends TransitionType {
  const TransitionTypeFadeScale({
    this.beginScale = .96,
    this.beginOpacity = 0,
    this.alignment = Alignment.center,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.curve,
  });

  final double beginScale;
  final double beginOpacity;
  final Alignment alignment;

  @override
  List<Object?> get props => [
    transitionDuration,
    reverseTransitionDuration,
    beginScale,
    beginOpacity,
    alignment,
  ];
}

class TransitionTypeBlur extends TransitionType {
  const TransitionTypeBlur({
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.curve,
  });
}

class TransitionTypeSlide extends TransitionType {
  const TransitionTypeSlide({
    required this.direction,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.curve,
  });
  final TransitionTypeSlideDirection direction;

  @override
  List<Object?> get props => [transitionDuration, reverseTransitionDuration, direction];
}

class TransitionTypeScale extends TransitionType {
  const TransitionTypeScale({
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.curve,
  });
}

enum TransitionTypeSlideDirection { verticalUp, horizontalFromRight }
