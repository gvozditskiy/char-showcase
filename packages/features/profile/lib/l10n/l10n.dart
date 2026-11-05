import 'package:flutter/widgets.dart';

import 'arb/profile_localizations.dart';

export 'arb/profile_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
