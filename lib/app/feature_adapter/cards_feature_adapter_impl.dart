import 'package:cards/cards.dart';
import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:cyoc/cyoc.dart';
import 'package:navigation/navigation.dart';

import '../model/rate_app_source.dart';
import '../repository/rate_app_repository.dart';
import '../usecase/show_rate_app_use_case.dart';

class CardsFeatureAdapterImpl implements CardsFeatureAdapter {
  const CardsFeatureAdapterImpl(
    this._appNavigator,
    this._rateAppRepository,
    this._showRateAppUseCase,
    this._logger,
  );

  final AppNavigator _appNavigator;
  final RateAppRepository _rateAppRepository;
  final ShowRateAppUseCase _showRateAppUseCase;
  final Logger _logger;

  @override
  Future<void> createCharacter() =>
      CyocFeature.openCreateCharacter(_appNavigator, CyocNavigationSource.feedPromoCard);

  @override
  Future<void> onCharacterLiked(CharacterModel character) async {
    const source = RateAppPopUpSource.firstCharacterLike;
    if (!_rateAppRepository.tryStartShow(source)) {
      return;
    }
    var shown = false;
    try {
      shown = await _showRateAppUseCase();
    } finally {
      try {
        await _rateAppRepository.finishShow(source, shown: shown);
      } on Object catch (e, stackTrace) {
        _logger.e(
          '[CardsFeatureAdapter] Failed to save rate app state',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
