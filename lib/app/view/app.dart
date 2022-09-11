// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:price_tracker/features/home/view/pages/price_tracker_page.dart';
import 'package:price_tracker/l10n/l10n.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

/// {@template app}
/// The root widget of our application.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({
    super.key,
    required PriceTrackerRepository priceTrackerRepository,
  }) : _priceTrackerRepository = priceTrackerRepository;

  final PriceTrackerRepository _priceTrackerRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => _priceTrackerRepository,
      child: const AppView(),
    );
  }
}

/// {@template app_view}
/// [MaterialApp] which sets the [PriceTrackerPage] as the `home`.
/// {@endtemplate}
class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PriceTrackerPage(),
    );
  }
}
