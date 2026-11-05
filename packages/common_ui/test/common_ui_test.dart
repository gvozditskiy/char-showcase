import 'package:common_ui/src/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('color extension', () {
    test('color alpha percent to hex', () {
      expect(const Color(0xFFFFFFFF).withAlphaPercent(100).a * 255, closeTo(0xFF, 0.5));
      expect(const Color(0xFFFFFFFF).withAlphaPercent(50).a * 255, closeTo(0x80, 0.5));
      expect(const Color(0xFFFFFFFF).withAlphaPercent(10).a * 255, closeTo(0x1A, 0.5));
      expect(const Color(0xFFFFFFFF).withAlphaPercent(0).a * 255, closeTo(0x00, 0.5));
    });
  });
}
