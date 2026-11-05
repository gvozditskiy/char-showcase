import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/color_extensions.dart';
import '../styles.dart';
import 'automation_semantics.dart';

class SurveyFreeInput extends StatelessWidget {
  const SurveyFreeInput({
    required FocusNode? focusNode,
    required TextEditingController textEditingController,
    required String? placeholder,
    String? semanticsIdentifier,
    bool autofocus = true,
    bool expands = false,
    EdgeInsets? contentPadding,
    BorderRadius? borderRadius,
    super.key,
  }) : _focusNode = focusNode,
       _textEditingController = textEditingController,
       _placeholder = placeholder,
       _semanticsIdentifier = semanticsIdentifier,
       _autofocus = autofocus,
       _expands = expands,
       _contentPadding = contentPadding,
       _borderRadius = borderRadius;

  final FocusNode? _focusNode;
  final TextEditingController _textEditingController;
  final String? _placeholder;
  final String? _semanticsIdentifier;
  final bool _autofocus;
  final bool _expands;
  final EdgeInsets? _contentPadding;
  final BorderRadius? _borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final styles = context.appStyle.text;
    final borderRadius = _borderRadius ?? context.appStyle.radii.smAll;
    return AutomationSemantics(
      identifier: _semanticsIdentifier,
      textField: true,
      enabled: true,
      child: TextField(
        autofocus: _autofocus,
        focusNode: _focusNode,
        onTapOutside: (point) => _focusNode?.unfocus(),
        scrollPadding: const EdgeInsets.only(bottom: 120),
        expands: _expands,
        textAlignVertical: TextAlignVertical.top,
        maxLines: _expands ? null : 10,
        inputFormatters: [LengthLimitingTextInputFormatter(800)],
        controller: _textEditingController,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: palette.textOnSurfacePrimary,
        style: styles.p1.copyWith(color: palette.textOnSurfacePrimary),
        decoration: InputDecoration(
          hintText: _placeholder,
          hintStyle: styles.p1.copyWith(color: palette.textOnSurfacePrimary.withAlphaPercent(30)),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: palette.outlineLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: palette.outlineDefault),
          ),
          contentPadding: _contentPadding ?? EdgeInsets.all(context.appStyle.spacing.space5),
        ),
      ),
    );
  }
}
