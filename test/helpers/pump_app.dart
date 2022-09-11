// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_tracker/features/home/cubit/price_tracker_cubit.dart';
import 'package:price_tracker/l10n/l10n.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }

  Future<void> pumpAppWithDependencies(
    Widget widget, {
    PriceTrackerRepository? repository,
    PriceTrackerCubit? cubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: repository,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: (cubit != null)
                ? BlocProvider.value(value: cubit, child: widget)
                : widget,
          ),
        ),
      ),
    );
  }

  Future<void> pumpWidgetWithDependencies(
    Widget widget, {
    PriceTrackerRepository? repository,
    PriceTrackerCubit? cubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: repository,
        child: (cubit != null)
            ? BlocProvider.value(value: cubit, child: widget)
            : widget,
      ),
    );
  }
}
