// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// {@template app_localizations}
/// A [LocalizationsDelegate] which uses the [AppLocalizations] class to
/// generate the localized strings.
/// {@endtemplate}
extension AppLocalizationsX on BuildContext {
  /// {@macro app_localizations}
  AppLocalizations get l10n => AppLocalizations.of(this);
}
