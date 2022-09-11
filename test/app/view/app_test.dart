// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:price_tracker/app/app.dart';
import 'package:price_tracker/features/home/cubit/price_tracker_cubit.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

import '../../helpers/helpers.dart';

class MockPriceTrackerCubit extends Mock implements PriceTrackerCubit {}

class MockPriceTrackerRepository extends Mock
    implements PriceTrackerRepository {}

void main() {
  group('App', () {
    late PriceTrackerRepository _priceTrackerRepository;

    setUp(() {
      _priceTrackerRepository = MockPriceTrackerRepository();
      when(_priceTrackerRepository.getActiveMarkets)
          .thenAnswer((invocation) => Result.success(Stream.value([])));
      when(_priceTrackerRepository.getErrorStream).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    testWidgets('renders PriceTrackerPage', (tester) async {
      await tester.pumpAppWithDependencies(
        App(priceTrackerRepository: _priceTrackerRepository),
        // cubit: _priceTrackerCubit,
      );
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
