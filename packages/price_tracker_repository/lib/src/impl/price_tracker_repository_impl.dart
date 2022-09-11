import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

///{@template price_tracker_repository}
/// An implementation of the [PriceTrackerRepository].
/// {@endtemplate}
class PriceTrackerRepositoryImpl implements PriceTrackerRepository {
  /// {@macro price_tracker_repository}
  PriceTrackerRepositoryImpl({
    required PriceTrackerApiClient priceTrackerApiClient,
  }) : _priceTrackerApiClient = priceTrackerApiClient;

  final PriceTrackerApiClient _priceTrackerApiClient;

  @override
  ActiveSymbolsResult getActiveMarkets() {
    try {
      final responseStream = _priceTrackerApiClient.getActiveMarkets();
      return Result.success(responseStream);
    } catch (e) {
      return Result.failure(
        PriceTrackerFailure('Something went wrong with the socket.'),
      );
    }
  }

  @override
  TicksResult getTicks() {
    try {
      final responseStream = _priceTrackerApiClient.getTicks();
      return Result.success(responseStream.stream);
    } catch (e) {
      return Result.failure(
        PriceTrackerFailure('Something went wrong with the socket.'),
      );
    }
  }

  @override
  RequestForTicksResult requestForTicks({required String selectedSymbol}) {
    try {
      _priceTrackerApiClient.requestForTicks(selectedSymbol: selectedSymbol);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(PriceTrackerFailure(e.toString()));
    }
  }

  @override
  void cancelTicks({required String tickId}) =>
      _priceTrackerApiClient.cancelStream(id: tickId);

  @override
  Stream<String> getErrorStream() {
    try {
      return _priceTrackerApiClient.getErrorStream().stream;
    } catch (e) {
      return Stream.value('Something went wrong with the connection.');
    }
  }

  @override
  void closeStream() => _priceTrackerApiClient.closeStream();
}
