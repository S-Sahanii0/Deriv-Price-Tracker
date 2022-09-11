import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:price_tracker/features/home/cubit/price_tracker_cubit.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

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
  group('PriceTrackerCubit', () {
    late PriceTrackerRepository _priceTrackerRepository;

    setUp(() {
      _priceTrackerRepository = MockPriceTrackerRepository();
    });

    group('initial state', () {
      test('state is pending during initialization', () {
        final priceTrackerCubit = PriceTrackerCubit(
          priceTrackerRepository: _priceTrackerRepository,
        );
        expect(
          priceTrackerCubit.state,
          PriceTrackerState.pending(activeSymbols: const []),
        );
      });
    });

    group('.getActiveMarkets', () {
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with success status and available active symbols',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          when(() => _priceTrackerRepository.getActiveMarkets()).thenAnswer(
            (_) => Result.success(Stream.value(availableSymbols)),
          );
          priceTrackerCubit.getActiveMarkets();
        },
        expect: () => <PriceTrackerState>[
          PriceTrackerState.pending(
            message: 'Fetching markets',
            activeSymbols: const [],
          ),
          PriceTrackerState.success(
            activeSymbols: availableSymbols,
            message: 'success',
          ),
        ],
      );
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with failure status',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          when(() => _priceTrackerRepository.getActiveMarkets()).thenAnswer(
            (_) => Result.failure(PriceTrackerFailure('Something went wrong')),
          );
          priceTrackerCubit.getActiveMarkets();
        },
        expect: () => <PriceTrackerState>[
          PriceTrackerState.pending(
            message: 'Fetching markets',
            activeSymbols: const [],
          ),
          PriceTrackerState.failure(
            message: 'Something went wrong',
            activeSymbols: const [],
          ),
        ],
      );
    });

    group('.selectMarket', () {
      const _selectedMarket = 'Forex'; //could be any market
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with success status and symbols of selected market',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          priceTrackerCubit.selectMarket(market: _selectedMarket);
        },
        seed: () => PriceTrackerState.pending(
          activeSymbols: availableSymbols,
        ),
        expect: () => <PriceTrackerState>[
          PriceTrackerState.success(
            activeSymbols: availableSymbols,
            selectedSymbols: availableSymbols
                .where((symbol) => symbol.marketDisplayName == _selectedMarket)
                .toList(),
          ),
        ],
      );
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        '''
emits state with success status and empty list of symbols 
        if market doesn't exist''',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          priceTrackerCubit.selectMarket(market: 'any');
        },
        seed: () => PriceTrackerState.pending(
          activeSymbols: availableSymbols,
        ),
        expect: () => <PriceTrackerState>[
          PriceTrackerState.success(
            activeSymbols: availableSymbols,
            selectedSymbols: const [],
          ),
        ],
      );
    });

    group('.requestForTicks', () {
      const _symbol = 'frxAUDCAD';
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with success status and ticks of selected symbol',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          when(
            () => _priceTrackerRepository.requestForTicks(
              selectedSymbol: _symbol,
            ),
          ).thenAnswer(
            (_) {
              return const Result.success(null);
            },
          );

          when(() => _priceTrackerRepository.getTicks()).thenAnswer(
            (_) => Result.success(Stream.value(tick)),
          );
          priceTrackerCubit.requestForTick(symbol: _symbol);
        },
        seed: () => PriceTrackerState.success(
          activeSymbols: availableSymbols,
          selectedSymbols: availableSymbols
              .where((symbol) => symbol.symbol == _symbol)
              .toList(),
        ),
        expect: () => <PriceTrackerState>[
          PriceTrackerState.pending(
            activeSymbols: availableSymbols,
            selectedSymbols: availableSymbols
                .where((symbol) => symbol.symbol == _symbol)
                .toList(),
            message: 'Fetching tick',
          ),
          PriceTrackerState.success(
            activeSymbols: availableSymbols,
            selectedSymbols: availableSymbols
                .where((symbol) => symbol.symbol == _symbol)
                .toList(),
            tick: tick,
            message: 'success',
          ),
        ],
      );
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with failure status',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) async {
          when(
            () => _priceTrackerRepository.requestForTicks(
              selectedSymbol: _symbol,
            ),
          ).thenAnswer(
            (_) {
              return Result.failure(
                PriceTrackerFailure('Something went wrong.'),
              );
            },
          );

          when(() => _priceTrackerRepository.getTicks()).thenAnswer(
            (_) => Result.success(Stream.value(tick)),
          );
          priceTrackerCubit.requestForTick(symbol: _symbol);
        },
        seed: () => PriceTrackerState.success(
          activeSymbols: availableSymbols,
          selectedSymbols: availableSymbols
              .where((symbol) => symbol.symbol == _symbol)
              .toList(),
        ),
        expect: () => <PriceTrackerState>[
          PriceTrackerState.pending(
            activeSymbols: availableSymbols,
            selectedSymbols: availableSymbols
                .where((symbol) => symbol.symbol == _symbol)
                .toList(),
            message: 'Fetching tick',
          ),
          PriceTrackerState.failure(
            activeSymbols: availableSymbols,
            selectedSymbols: availableSymbols
                .where((symbol) => symbol.symbol == _symbol)
                .toList(),
            message: 'Something went wrong.',
          ),
        ],
      );
    });

    group('.receiveError', () {
      blocTest<PriceTrackerCubit, PriceTrackerState>(
        'emits state with failure status',
        build: () {
          return PriceTrackerCubit(
            priceTrackerRepository: _priceTrackerRepository,
          );
        },
        act: (priceTrackerCubit) {
          when(
            () => _priceTrackerRepository.getErrorStream(),
          ).thenAnswer((_) => Stream.value('An error message.'));
          priceTrackerCubit.receiveError();
        },
        expect: () => <PriceTrackerState>[
          PriceTrackerState.failure(
            activeSymbols: const [],
            message: 'An error message.',
          ),
        ],
      );
    });
  });
}
