import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/src/core/core.dart';

/// A type representing either a [PriceTrackerFailure] or
/// a [Stream<List<ActiveSymbol>>].
typedef ActiveSymbolsResult
    = Result<PriceTrackerFailure, Stream<List<ActiveMarketSymbol>>>;

/// A type representing either a [PriceTrackerFailure] or a [Stream<Tick>].
typedef TicksResult = Result<PriceTrackerFailure, Stream<Tick>?>;

/// A type representing either a [PriceTrackerFailure] or nothing if success.
typedef RequestForTicksResult = Result<PriceTrackerFailure, void>;

/// {@template price_tracker_repository}
/// A Dart class that exposes methods to
/// implement price tracker functionalities
/// {@endtemplate}
abstract class PriceTrackerRepository {
  /// {@macro price_tracker_repository}

  /// A method that returns continuous stream of available markets.
  ActiveSymbolsResult getActiveMarkets();

  /// A method that returns continuous
  /// stream of price updates of the given symbol.
  TicksResult getTicks();

  ///Requests the server to send stream of price updates
  ///of the [Selected active symbol]
  RequestForTicksResult requestForTicks({
    required String selectedSymbol,
  });

  /// A method to cancel the stream of specific id
  void cancelTicks({required String tickId});

  /// A method to get the stream of errors received from the server.
  Stream<String> getErrorStream();

  /// A method to close all the existing stream
  void closeStream();
}
