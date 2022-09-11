import 'dart:async';
import 'dart:convert';

import 'package:price_tracker_api_client/src/models/active_symbol.dart';
import 'package:price_tracker_api_client/src/models/tick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// {@template socket_exception}
/// Thrown if there is an issue while listening to the server
/// {@endtemplate}
class SocketException implements Exception {
  /// {@macro socket_exception}
  SocketException({required this.errorMessage});

  /// Message that describes the error encountered
  final String errorMessage;
}

/// {@template price_tracker_api_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PriceTrackerApiClient {
  /// {@macro price_tracker_api_client}
  PriceTrackerApiClient({WebSocketChannel? ws})
      : _ws = ws ??
            WebSocketChannel.connect(
              Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=32618'),
            ) {
    _listenToTheServer();

    /// Request for active markets.
    _addMessageToSink(
      message: jsonEncode({'active_symbols': 'brief', 'product_type': 'basic'}),
    );
  }

  late final WebSocketChannel _ws;

  /// List of all the active symbols (available markets for trading) at Deriv.
  final StreamController<List<ActiveMarketSymbol>> _listOfAvailableSymbols =
      StreamController.broadcast();

  /// Stream of error messages received.
  final StreamController<String> _errorStream = StreamController.broadcast();

  ///Continuous stream of spot price updates for a given symbol.
  final StreamController<Tick> _ticks = StreamController.broadcast();

  /// A method that returns continuous stream of available markets.
  Stream<List<ActiveMarketSymbol>> getActiveMarkets() =>
      _listOfAvailableSymbols.stream;

  /// A method that returns continuous stream of error message received.
  StreamController<String> getErrorStream() => _errorStream;

  /// A method that returns continuous stream of
  /// spot price updates for a given symbol.
  StreamController<Tick> getTicks() => _ticks;

  ///Receives messages from the server continuously
  void _listenToTheServer() {
    void _assignResponseToStream(Map<String, dynamic> response) {
      if (response.containsKey('active_symbols')) {
        final activeSymbolsEvent = List<Map<String, dynamic>>.from(
          response['active_symbols'] as List<dynamic>,
        ).map(ActiveMarketSymbol.fromJson).toList();
        _listOfAvailableSymbols.add(activeSymbolsEvent);
      }
      if (response.containsKey('tick')) {
        _ticks.add(Tick.fromJson(response['tick'] as Map<String, dynamic>));
      }
      if (response.containsKey('error')) {
        _errorStream.add(
          (response['error'] as Map<String, dynamic>)['message'].toString(),
        );
      }
    }

    _ws.stream.listen(
      (event) {
        try {
          final response = jsonDecode(event as String) as Map<String, dynamic>;
          _assignResponseToStream(response);
        } catch (e) {
          throw SocketException(errorMessage: e.toString());
        }
      },
      onError: (dynamic error) {
        throw SocketException(
          errorMessage: 'Something went wrong with the request',
        );
      },
    );
  }

  ///Sends a message to the server
  void _addMessageToSink({required String message}) {
    try {
      _ws.sink.add(message);
    } catch (e) {
      throw SocketException(errorMessage: e.toString());
    }
  }

  ///Requests the server to send stream of price updates
  ///of the [Selected active symbol]
  void requestForTicks({required String selectedSymbol}) {
    _addMessageToSink(
      message: jsonEncode({'ticks': selectedSymbol, 'subscribe': 1}),
    );
  }

  ///Immediately cancels the real-time stream of messages with a specific ID.
  void cancelStream({required String id}) {
    _addMessageToSink(
      message: jsonEncode({'forget': id}),
    );
  }

  ///Immediately cancels the real-time stream listening to.
  void closeStream() {
    _ticks.close();
    _listOfAvailableSymbols.close();
    _errorStream.close();
    _ws.sink.close();
  }
}
