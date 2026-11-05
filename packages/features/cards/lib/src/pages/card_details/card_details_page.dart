import 'dart:async';

import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/arb/app_localizations.dart' as local_strings;
import '../../cubit/card_details/card_details_cubit.dart';
import '../../widgets/character_feed_avatar.dart';
import '../../widgets/feed_like_button.dart';
import '../../widgets/rounded_interest_item.dart';

part 'widgets/card_details_about_tab.dart';
part 'widgets/card_details_header.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({required this.characterId, super.key});

  final String characterId;

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  late final CardDetailsCubit _cubit;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<CardDetailsCubit>();
    unawaited(_cubit.onOpened(widget.characterId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = local_strings.AppLocalizations.of(context);
    return BlocConsumer<CardDetailsCubit, CardDetailsState>(
      bloc: _cubit,
      listenWhen: (previous, current) => previous.toastType != current.toastType,
      listener: (context, state) {
        switch (state.toastType) {
          case CardDetailsToastType.likeError:
            context.showRootToast(strings.cardsLikeErrorToast);
            _cubit.onToastShown();
          case CardDetailsToastType.none:
            break;
        }
      },
      builder: (context, state) {
        final character = state.character;
        return ColoredBox(
          color: context.palette.surfaceWhite,
          child: Stack(
            children: [
              if (character != null)
                Positioned.fill(child: _buildContent(context, state, character))
              else if (state.loadingInfo)
                const Center(child: CharLoader(dark: true, dimension: 48))
              else
                _CardDetailsNotFound(
                  title: strings.detailsNotFoundTitle,
                  description: strings.detailsNotFoundDescription,
                ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8,
                right: 16,
                child: CharCloseButton(
                  onTap: _cubit.onClose,
                  withBackground: true,
                  semanticsIdentifier: 'card_details_close_button',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CardDetailsState state, CharacterModel character) {
    final imageHeight = MediaQuery.sizeOf(context).height * 2 / 3;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: _CardDetailsHeader(
            character: character,
            height: imageHeight,
            pageController: _pageController,
            processing: state.processing,
            onLike: character.hasFeedLike ? _cubit.onUnlike : _cubit.onLike,
          ),
        ),
        SliverToBoxAdapter(
          child: _CardDetailsAboutTab(character: character, bottomInset: 40 + bottomPadding),
        ),
      ],
    );
  }
}

class _CardDetailsNotFound extends StatelessWidget {
  const _CardDetailsNotFound({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.appStyle.text.h5.copyWith(color: palette.textOnSurfacePrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: context.appStyle.text.p2.copyWith(color: palette.textOnSurfaceSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
