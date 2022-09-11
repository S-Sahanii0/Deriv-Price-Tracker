import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:price_tracker/features/home/cubit/price_tracker_cubit.dart';
import 'package:price_tracker/features/home/view/pages/price_tracker_page.dart';
import 'package:price_tracker/features/home/view/widgets/widgets.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

import '../../../../helpers/helpers.dart';

class MockPriceTrackerCubit extends Mock implements PriceTrackerCubit {}

class MockPriceTrackerRepository extends Mock
    implements PriceTrackerRepository {}

///This is the mock response that will be received when
///mock active symbols message is sent to the server.
final mockActiveSymbolResponse = {
  'active_symbols': [
    {
      'allow_forward_starting': 0,
      'display_name': 'AUD Basket',
      'exchange_is_open': 1,
      'is_trading_suspended': 0,
      'market': 'basket_index',
      'market_display_name': 'Basket Indices',
      'pip': 0.001,
      'submarket': 'forex_basket',
      'submarket_display_name': 'Forex Basket',
      'symbol': 'WLDAUD',
      'symbol_type': 'forex_basket'
    },
    {
      'allow_forward_starting': 1,
      'display_name': 'AUD/CAD',
      'exchange_is_open': 1,
      'is_trading_suspended': 0,
      'market': 'forex',
      'market_display_name': 'Forex',
      'pip': 0.00001,
      'submarket': 'minor_pairs',
      'submarket_display_name': 'Minor Pairs',
      'symbol': 'frxAUDCAD',
      'symbol_type': 'forex'
    },
  ],
  'msg_type': 'active_symbols'
};

final mockTicks = {
  'echo_req': {'subscribe': 1, 'ticks': 'cryBTCUSD'},
  'msg_type': 'tick',
  'subscription': {'id': '82df3722-522c-243a-5962-45db2a96d8f4'},
  'tick': {
    'ask': 23437.812,
    'bid': 23433.888,
    'epoch': 1660784552,
    'id': '82df3722-522c-243a-5962-45db2a96d8f4',
    'pip_size': 3,
    'quote': 23435.85,
    'symbol': 'cryBTCUSD'
  }
};

final tick = Tick.fromJson(mockTicks['tick']! as Map<String, dynamic>);

final availableSymbols =
    (mockActiveSymbolResponse['active_symbols']! as List<Map<String, dynamic>>)
        .map(ActiveMarketSymbol.fromJson)
        .toList();

void main() {
  group('PriceTrackerPage', () {
    late PriceTrackerCubit _priceTrackerCubit;
    late PriceTrackerRepository _priceTrackerRepository;
    setUp(() {
      _priceTrackerCubit = MockPriceTrackerCubit();
      _priceTrackerRepository = MockPriceTrackerRepository();
      when(_priceTrackerRepository.getActiveMarkets).thenAnswer(
        (_) => Result.success(Stream.value(availableSymbols)),
      );
      when(_priceTrackerRepository.getErrorStream).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    testWidgets('renders price tracker view', (tester) async {
      when(() => _priceTrackerCubit.state).thenAnswer(
        (_) => PriceTrackerState.pending(
          activeSymbols: const [],
          message: 'Fetching markets',
        ),
      );

      await tester.pumpAppWithDependencies(
        const PriceTrackerPage(),
        cubit: _priceTrackerCubit,
        repository: _priceTrackerRepository,
      );

      expect(find.byType(PriceTrackerView), findsOneWidget);
    });

    testWidgets('displays dropdown button with list of markets',
        (tester) async {
      when(() => _priceTrackerCubit.state).thenAnswer(
        (invocation) =>
            PriceTrackerState.success(activeSymbols: availableSymbols),
      );
      await tester.pumpAppWithDependencies(
        const PriceTrackerPage(),
        cubit: _priceTrackerCubit,
        repository: _priceTrackerRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomDropDownButton), findsOneWidget);
    });

    testWidgets('displays snackbar with error message', (tester) async {
      when(() => _priceTrackerRepository.getErrorStream()).thenAnswer(
        (_) => Stream.value('Error message'),
      );
      when(() => _priceTrackerCubit.state).thenAnswer(
        (invocation) => PriceTrackerState.failure(
          message: 'Error message.',
          activeSymbols: const [],
        ),
      );
      await tester.pumpAppWithDependencies(
        const PriceTrackerPage(),
        cubit: _priceTrackerCubit,
        repository: _priceTrackerRepository,
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
