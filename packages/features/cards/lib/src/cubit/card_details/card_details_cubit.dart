import 'dart:async';

import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

import '../../cards_feature_adapter.dart';
import '../../model/event/card_details_opened_event.dart';
import '../../model/event/card_events.dart';

part 'card_details_state.dart';

class CardDetailsCubit extends Cubit<CardDetailsState> with SafeCubit<CardDetailsState> {
  CardDetailsCubit(
    this._logger,
    this._navigator,
    this._featureAdapter,
    this._analyticsService,
    this._characterRepository,
  ) : super(const CardDetailsState());

  final Logger _logger;
  final AppNavigator _navigator;
  final CardsFeatureAdapter _featureAdapter;
  final AnalyticsService _analyticsService;
  final CharacterRepository _characterRepository;

  Future<void> onOpened(String characterId) async {
    emit(state.copyWith(loadingInfo: true));
    try {
      final character = await _characterRepository.getCharacter(characterId);
      if (character == null) {
        safeEmit(state.copyWith(loadingInfo: false));
        return;
      }
      safeEmit(state.copyWith(character: character, loadingInfo: false));
      _analyticsService.trackEvent(CharacterDetailsOpenedEvent(character));
    } catch (e) {
      _logger.e('[CARD_DETAILS] load failed for $characterId', error: e);
      safeEmit(state.copyWith(loadingInfo: false));
    }
  }

  Future<void> onLike() async {
    final character = state.character;
    if (state.processing || character == null) {
      return;
    }
    emit(state.copyWith(processing: true));
    _analyticsService.trackEvent(CharacterLikedEvent(character));
    try {
      await _characterRepository.likeFeedCharacter(character.id);
      final likedCharacter = character.copyWith(hasFeedLike: true);
      safeEmit(state.copyWith(character: likedCharacter));
      unawaited(_featureAdapter.onCharacterLiked(likedCharacter));
    } catch (e) {
      _logger.e('[CARD_DETAILS] like failed', error: e);
      safeEmit(state.copyWith(toastType: CardDetailsToastType.likeError));
    } finally {
      safeEmit(state.copyWith(processing: false));
    }
  }

  Future<void> onUnlike() async {
    final character = state.character;
    if (state.processing || character == null) {
      return;
    }
    emit(state.copyWith(processing: true));
    _analyticsService.trackEvent(CharacterUnlikedEvent(character));
    try {
      await _characterRepository.unlikeFeedCharacter(character.id);
      safeEmit(state.copyWith(character: character.copyWith(hasFeedLike: false)));
    } catch (e) {
      _logger.e('[CARD_DETAILS] unlike failed', error: e);
      safeEmit(state.copyWith(toastType: CardDetailsToastType.likeError));
    } finally {
      safeEmit(state.copyWith(processing: false));
    }
  }

  void onToastShown() {
    if (state.toastType == CardDetailsToastType.none) {
      return;
    }
    safeEmit(state.copyWith(toastType: CardDetailsToastType.none));
  }

  void onClose() {
    if (state.processing) {
      return;
    }
    _navigator.goBack<void>();
  }
}
