import 'package:flutter/widgets.dart';
import 'package:parker_flutter_lab/l10n/gen/app_localizations.dart';

export 'package:parker_flutter_lab/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
