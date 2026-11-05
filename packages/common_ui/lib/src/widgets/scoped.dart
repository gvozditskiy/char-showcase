import 'package:flutter/material.dart';

class Scoped extends StatefulWidget {
  const Scoped({required this.child, required this.onInit, required this.onDispose, super.key});

  final Widget child;
  final VoidCallback onInit;
  final VoidCallback onDispose;

  @override
  State<Scoped> createState() => _ScopedState();
}

class _ScopedState extends State<Scoped> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    widget.onInit.call();
    super.initState();
  }

  @override
  void dispose() {
    widget.onDispose.call();
    super.dispose();
  }
}
