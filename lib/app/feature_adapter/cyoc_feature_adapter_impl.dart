import 'package:cards/cards.dart';
import 'package:cyoc/cyoc.dart';
import 'package:navigation/navigation.dart';

class CyocFeatureAdapterImpl implements CyocFeatureAdapter {
  const CyocFeatureAdapterImpl(this._navigator);

  final AppNavigator _navigator;

  @override
  void openCards() => CardsFeature.openFeature(_navigator);
}
