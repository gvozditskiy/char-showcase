import 'package:flutter/widgets.dart';

class AutomationSemantics extends StatelessWidget {
  const AutomationSemantics({
    required this.child,
    super.key,
    this.identifier,
    this.button = false,
    this.textField = false,
    this.enabled,
    this.selected,
  });

  final String? identifier;
  final bool button;
  final bool textField;
  final bool? enabled;
  final bool? selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final identifier = this.identifier;
    if (identifier == null) {
      return Semantics(child: child);
    }

    return Semantics(
      identifier: identifier,
      container: true,
      button: button,
      textField: textField,
      enabled: enabled,
      selected: selected,
      child: child,
    );
  }
}

abstract final class AutomationId {
  static String join(Iterable<String?> parts) {
    return parts.whereType<String>().map(normalizePart).where((part) => part.isNotEmpty).join('_');
  }

  static String normalizePart(String value) {
    var normalized = value.trim().toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '_');
    while (normalized.startsWith('_')) {
      normalized = normalized.substring(1);
    }
    while (normalized.endsWith('_')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
