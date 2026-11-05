import 'package:flutter/material.dart';

class CyocSyncedTextController extends TextEditingController {
  CyocSyncedTextController({required String initialText}) : super(text: initialText);

  void syncFrom(String value) {
    if (value == text) {
      return;
    }
    this.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
