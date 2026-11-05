import 'dart:async';
import 'dart:math';

import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/arb/app_localizations.dart' as cards_l10n;
import '../../cubit/cards_feed/cards_feed_cubit.dart';
import '../../widgets/character_feed_avatar.dart';
import '../../widgets/feed_like_button.dart';

part 'widgets/cards_feed_card.dart';
part 'widgets/cards_feed_create_character_card.dart';
part 'widgets/cards_feed_item_page.dart';
part 'widgets/cards_feed_promo_benefit.dart';
part 'widgets/cards_feed_scaffold.dart';
part 'widgets/cards_feed_status_views.dart';
part 'widgets/cards_feed_top_overlay.dart';

class CardsFeedPage extends StatefulWidget {
  const CardsFeedPage({super.key});

  @override
  State<CardsFeedPage> createState() => _CardsFeedPageState();
}

class _CardsFeedPageState extends State<CardsFeedPage> {
  late final CardsFeedCubit _cubit;
  final PageController _pageController = PageController();

  int _handledAdvanceRequestId = 0;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<CardsFeedCubit>();
    unawaited(_cubit.onOpened());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CardsFeedCubit, CardsFeedState>(
      bloc: _cubit,
      listenWhen: (previous, current) =>
          previous.advanceRequestId != current.advanceRequestId ||
          previous.toastType != current.toastType,
      listener: (context, state) {
        _handleToast(context, state);
        _handleAdvanceRequest(state);
      },
      builder: (context, state) {
        final strings = cards_l10n.AppLocalizations.of(context);
        if (state.initialLoading && state.characters.isEmpty) {
          return const _FeedScaffold(children: [_FeedLoadingView()]);
        }

        if (state.loadFailed && state.characters.isEmpty) {
          return _FeedScaffold(
            children: [
              _FeedEmptyView(
                title: strings.cardsFeedErrorTitle,
                description: strings.cardsFeedErrorDescription,
                actionTitle: strings.cardsFeedRetryButtonTitle,
                onRetry: _cubit.onRefresh,
              ),
            ],
          );
        }

        if (state.characters.isEmpty) {
          return _FeedScaffold(
            children: [
              _FeedEmptyView(
                title: strings.cardsFeedEmptyTitle,
                description: strings.cardsFeedEmptyDescription,
                actionTitle: strings.cardsFeedCreateCharacterButton,
                onRetry: _cubit.onCreateCharacterPromoTap,
              ),
            ],
          );
        }

        final feedItems = state.feedItems;
        return _FeedScaffold(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _cubit.onPageChanged,
              itemCount: feedItems.length,
              itemBuilder: (context, index) {
                final item = feedItems[index];
                return _FeedItemPage(
                  key: _feedPageKey(item),
                  cubit: _cubit,
                  state: state,
                  item: item,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  ValueKey<String> _feedPageKey(CardsFeedItem item) {
    return switch (item) {
      CardsFeedLoadingItem() => const ValueKey('cards_feed_loading'),
      CardsFeedCreateCharacterItem() => const ValueKey('cards_feed_create_character'),
      CardsFeedCharacterItem(:final character) => ValueKey('cards_feed_character_${character.id}'),
    };
  }

  void _handleToast(BuildContext context, CardsFeedState state) {
    final strings = cards_l10n.AppLocalizations.of(context);
    final text = switch (state.toastType) {
      CardsFeedToastType.none => null,
      CardsFeedToastType.error => strings.cardsErrorToast,
      CardsFeedToastType.likeError => strings.cardsLikeErrorToast,
      CardsFeedToastType.characterJoined => strings.cardsCharacterJoinedToast(
        state.toastCharacterName,
      ),
    };
    if (text == null) {
      return;
    }
    context.showRootToast(text);
    _cubit.onToastShown();
  }

  void _handleAdvanceRequest(CardsFeedState state) {
    if (state.advanceRequestId == _handledAdvanceRequestId) {
      return;
    }

    _handledAdvanceRequestId = state.advanceRequestId;
    final targetCharacterId = state.advanceToCharacterId;
    if (targetCharacterId == null) {
      return;
    }
    final page = state.feedPageIndexForCharacterId(targetCharacterId);
    if (page == null || !_pageController.hasClients) {
      return;
    }
    _pageController.jumpToPage(page);
  }
}
