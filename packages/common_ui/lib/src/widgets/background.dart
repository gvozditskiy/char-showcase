import 'package:flutter/material.dart';

import '../styles.dart';

class CharBackground extends StatelessWidget {
  const CharBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: ColoredBox(color: context.palette.surfaceWhite));
  }
}
