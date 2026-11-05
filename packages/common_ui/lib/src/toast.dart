import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'styles.dart';

final Map<String, ToastFuture> _toastFutures = {};

extension ToastX on BuildContext {
  void showToast(String text, {Duration? duration}) {
    if (_toastFutures.containsKey(text)) {
      _toastFutures[text]?.dismiss();
    }
    final style = appStyle;
    final toast = showToastWidget(
      Padding(
        padding: EdgeInsets.all(style.spacing.space5),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: style.radii.mdAll,
                  color: style.palette.surfaceMedium,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: style.spacing.space4,
                vertical: style.spacing.space3,
              ),
              child: Text(
                text,
                style: style.text.p2.copyWith(color: style.palette.textOnSurfaceFixedWhite),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      context: this,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.top,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      dismissOtherToast: true,
      duration: duration,
      onDismiss: () {
        _toastFutures.remove(text);
      },
    );
    _toastFutures[text] = toast;
  }
}
