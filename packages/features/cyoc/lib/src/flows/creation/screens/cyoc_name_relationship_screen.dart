import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../cyoc_creation_cubit.dart';
import 'widgets/cyoc_attribute_selectors.dart';
import 'widgets/cyoc_creation_step_layout.dart';
import 'widgets/cyoc_section_header.dart';
import 'widgets/cyoc_suggest_button.dart';
import 'widgets/cyoc_synced_text_controller.dart';

class CyocNameRelationshipScreen extends StatefulWidget {
  const CyocNameRelationshipScreen({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  static const double _avatarSize = 96;
  static const double _avatarBottomGap = 28;
  static const double _nameInputHeight = 44;
  static const EdgeInsets _namePadding = EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static const BorderRadius _inputRadius = BorderRadius.all(Radius.circular(25));

  @override
  State<CyocNameRelationshipScreen> createState() => _CyocNameRelationshipScreenState();
}

class _CyocNameRelationshipScreenState extends State<CyocNameRelationshipScreen> {
  late final CyocSyncedTextController _controller = CyocSyncedTextController(
    initialText: widget.cubit.state.choice.name,
  )..addListener(() => widget.cubit.updateName(_controller.text));
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return AutomationSemantics(
      identifier: 'cyoc_creation_name_relationship_screen',
      child: BlocConsumer<CyocCreationCubit, CyocCreationState>(
        bloc: widget.cubit,
        listenWhen: (previous, current) => previous.choice.name != current.choice.name,
        listener: (context, state) => _controller.syncFrom(state.choice.name),
        builder: (context, state) {
          final avatarUrl = state.result?.avatarUrl;
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              if (avatarUrl != null) ...[
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      avatarUrl,
                      width: CyocNameRelationshipScreen._avatarSize,
                      height: CyocNameRelationshipScreen._avatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: CyocNameRelationshipScreen._avatarBottomGap),
              ],
              CyocSectionHeader(
                title: strings.cyocCreationNameSectionTitle,
                trailing: CyocSuggestButton(
                  onClick: widget.cubit.suggestName,
                  semanticsIdentifier: 'cyoc_creation_name_suggest_button',
                ),
              ),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: SizedBox(
                  height: CyocNameRelationshipScreen._nameInputHeight,
                  child: SurveyFreeInput(
                    focusNode: _focusNode,
                    textEditingController: _controller,
                    placeholder: strings.cyocCreationNameHint,
                    semanticsIdentifier: 'cyoc_creation_name_input',
                    autofocus: false,
                    expands: true,
                    contentPadding: CyocNameRelationshipScreen._namePadding,
                    borderRadius: CyocNameRelationshipScreen._inputRadius,
                  ),
                ),
              ),
              SizedBox(height: style.spacing.space4),
              CyocSectionHeader(title: strings.cyocCreationStartAsTitle),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: CyocRelationshipSelector(
                  selected: state.relationship,
                  onSelected: widget.cubit.updateRelationship,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CyocNameRelationshipFooter extends StatelessWidget implements PreferredSizeWidget {
  const CyocNameRelationshipFooter({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Size get preferredSize => Size.fromHeight(ThemedButtonSize.m.height);

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocBuilder<CyocCreationCubit, CyocCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return ThemedButton(
          text: strings.continueButtonTitle,
          size: ThemedButtonSize.m,
          theme: ThemedButtonTheme.primary(context, enabled: state.canCreateCharacter),
          semanticsIdentifier: 'cyoc_creation_create_character_button',
          enabled: state.canCreateCharacter,
          isLoading: state.processing,
          onPressed: cubit.createCharacter,
        );
      },
    );
  }
}
