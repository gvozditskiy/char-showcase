import 'package:flutter/widgets.dart';

import 'arb/cyoc_localizations.dart';

export 'arb/cyoc_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
