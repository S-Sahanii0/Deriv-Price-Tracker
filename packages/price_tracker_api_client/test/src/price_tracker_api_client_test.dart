// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

final availableSymbols =
    (mockActiveSymbolResponse['active_symbols']! as List<Map<String, dynamic>>)
        .map(ActiveMarketSymbol.fromJson)
        .toList();

final tick = Tick.fromJson(mockTicks['tick']! as Map<String, dynamic>);

class MockIOWebSocket extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  group('PriceTrackerApiClient', () {
    late WebSocketChannel _ws;
    late MockWebSocketSink _wsSink;
    late PriceTrackerApiClient _client;

    setUp(() {
      _ws = MockIOWebSocket();
      _wsSink = MockWebSocketSink();
      when(() => _ws.stream).thenAnswer(
        (invocation) => Stream.value(jsonEncode(mockActiveSymbolResponse)),
      );
      when(() => _wsSink.add(any<dynamic>())).thenAnswer((_) {});
      when(() => _ws.sink).thenAnswer((invocation) => _wsSink);
      _client = PriceTrackerApiClient(ws: _ws);
    });

    test('can be instantiated', () {
      expect(_client, isNotNull);
    });

    test('fetches the available symbols on instantiation', () {
      expect(
        PriceTrackerApiClient(ws: _ws).getActiveMarkets(),
        emits(availableSymbols),
      );
    });

    group('ticks', () {
      setUp(() {
        when(() => _ws.stream)
            .thenAnswer((invocation) => Stream.value(jsonEncode(mockTicks)));
        when(() => _wsSink.add(any<dynamic>())).thenAnswer((_) {});
        when(() => _ws.sink).thenAnswer((invocation) => _wsSink);
        _client = PriceTrackerApiClient(ws: _ws);
      });

      test('stream of ticks received on symbol sent as message to server', () {
        _client = PriceTrackerApiClient(ws: _ws)
          ..requestForTicks(selectedSymbol: 'any');
        expect(
          _client.getTicks().stream,
          emits(tick),
        );
      });
    });
  });
}
