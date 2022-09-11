// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

class MockPriceTrackerApiClient extends Mock implements PriceTrackerApiClient {}

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
  group('PriceTrackerRepository', () {
    late PriceTrackerRepository _priceTrackerRepository;
    late PriceTrackerApiClient _priceTrackerApiClient;

    setUp(() {
      _priceTrackerApiClient = MockPriceTrackerApiClient();
      _priceTrackerRepository = PriceTrackerRepositoryImpl(
        priceTrackerApiClient: _priceTrackerApiClient,
      );
    });

    test('can be instantiated', () {
      expect(_priceTrackerRepository, isNotNull);
    });

    group('.getActiveMarkets', () {
      test('returns result with success value', () {
        when(
          () => _priceTrackerApiClient.getActiveMarkets(),
        ).thenAnswer((invocation) => Stream.value(availableSymbols));
        expect(
          _priceTrackerRepository.getActiveMarkets(),
          isA<Result<PriceTrackerFailure, Stream<List<ActiveMarketSymbol>>>>()
              .having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) => PriceTrackerFailure('$e'),
            ),
            'success',
            emits(availableSymbols),
          ),
        );
      });
      test('returns result with failure value', () {
        when(
          () => _priceTrackerApiClient.getActiveMarkets(),
        ).thenThrow(SocketException(errorMessage: 'Something went wrong.'));
        expect(
          _priceTrackerRepository.getActiveMarkets(),
          isA<Result<PriceTrackerFailure, Stream<List<ActiveMarketSymbol>>>>()
              .having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) =>
                  PriceTrackerFailure('Something went wrong with the socket.'),
            ),
            'failure',
            PriceTrackerFailure('Something went wrong with the socket.'),
          ),
        );
      });
    });
    group('.requestForTicks', () {
      test('returns result with success value', () {
        when(
          () => _priceTrackerApiClient.requestForTicks(selectedSymbol: 'any'),
        ).thenAnswer((_) {});
        expect(
          _priceTrackerRepository.requestForTicks(selectedSymbol: 'any'),
          isA<Result<PriceTrackerFailure, void>>().having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) => PriceTrackerFailure('$e'),
            ),
            'success',
            null,
          ),
        );
      });
      test('returns result with failure value', () {
        when(
          () => _priceTrackerApiClient.requestForTicks(selectedSymbol: 'any'),
        ).thenThrow(SocketException(errorMessage: 'Something went wrong.'));
        expect(
          _priceTrackerRepository.requestForTicks(selectedSymbol: 'any'),
          isA<Result<PriceTrackerFailure, void>>().having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) =>
                  PriceTrackerFailure('Something went wrong with the socket.'),
            ),
            'failure',
            PriceTrackerFailure('Something went wrong with the socket.'),
          ),
        );
      });
    });
    group('.getTicks', () {
      test('returns result with success value', () {
        when(
          () => _priceTrackerApiClient.getTicks(),
        ).thenAnswer((_) {
          return StreamController()..add(tick);
        });
        expect(
          _priceTrackerRepository.getTicks(),
          isA<Result<PriceTrackerFailure, Stream<Tick>?>>().having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) => PriceTrackerFailure('$e'),
            ),
            'success',
            emits(tick),
          ),
        );
      });
      test('returns result with failure value', () {
        when(
          () => _priceTrackerApiClient.getTicks(),
        ).thenThrow(SocketException(errorMessage: 'Something went wrong.'));
        expect(
          _priceTrackerRepository.getTicks(),
          isA<Result<PriceTrackerFailure, Stream<Tick>?>>().having(
            (p0) => p0.when(
              success: (val) => val,
              failure: (e) =>
                  PriceTrackerFailure('Something went wrong with the socket.'),
            ),
            'failure',
            PriceTrackerFailure('Something went wrong with the socket.'),
          ),
        );
      });
    });
    group('.getErrorStream', () {
      test('returns stream of String (error message)', () {
        when(
          () => _priceTrackerApiClient.getErrorStream(),
        ).thenAnswer((_) {
          return StreamController()..add('Any error message');
        });
        expect(
          _priceTrackerRepository.getErrorStream(),
          emits('Any error message'),
        );
      });
    });
  });
}
