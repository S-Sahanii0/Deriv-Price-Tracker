part of 'price_tracker_cubit.dart';

/// {@template price_tracker_state}
/// Describes the different states of the [PriceTrackerCubit].
/// The [message] will be null state is not [PriceTrackerState.failure].
/// Instances should be created using the factory methods to
/// make the possible states explicit and typed.
/// {@endtemplate}
@immutable
class PriceTrackerState {
  /// {@macro price_tracker_state}
  const PriceTrackerState._({
    required this.status,
    required this.activeMarketSymbols,
    this.selectedMarketSymbols,
    this.tick,
    this.message,
  });

  /// Returns a [PriceTrackerState] with the [status] set to
  /// [PriceTrackerState.pending]. Denotes the pending state.
  factory PriceTrackerState.pending({
    String? message,
    required List<ActiveMarketSymbol> activeSymbols,
    List<ActiveMarketSymbol>? selectedSymbols,
  }) =>
      PriceTrackerState._(
        status: PriceTrackerStatus.pending,
        message: message,
        activeMarketSymbols: activeSymbols,
        selectedMarketSymbols: selectedSymbols,
      );

  /// Returns a [PriceTrackerState] with the [status] set to
  /// [PriceTrackerStatus.success] and the market details.
  /// The [activeSymbols] should not be empty when the status is success.
  factory PriceTrackerState.success({
    required List<ActiveMarketSymbol> activeSymbols,
    Tick? tick,
    String? message,
    List<ActiveMarketSymbol>? selectedSymbols,
  }) {
    return PriceTrackerState._(
      status: PriceTrackerStatus.success,
      activeMarketSymbols: activeSymbols,
      tick: tick,
      message: message,
      selectedMarketSymbols: selectedSymbols,
    );
  }

  /// Returns a [PriceTrackerState] with the [status] set to
  /// [PriceTrackerStatus.failure] and the error message.
  factory PriceTrackerState.failure({
    required String message,
    required List<ActiveMarketSymbol> activeSymbols,
    List<ActiveMarketSymbol>? selectedSymbols,
  }) =>
      PriceTrackerState._(
        status: PriceTrackerStatus.failure,
        message: message,
        activeMarketSymbols: activeSymbols,
        selectedMarketSymbols: selectedSymbols,
      );

  /// Represents the current status of a request/process.
  final PriceTrackerStatus status;

  /// Represents the stream of active symbol of the selected market.
  final List<ActiveMarketSymbol> activeMarketSymbols;

  /// Represents the stream of symbol of the selected market.
  final List<ActiveMarketSymbol>? selectedMarketSymbols;

  /// Represents the stream of prices.
  final Tick? tick;

  /// Represents the message to notify anything.
  final String? message;

  /// The equality operator.
  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;
    return other is PriceTrackerState &&
        runtimeType == other.runtimeType &&
        status == other.status &&
        listEquals(activeMarketSymbols, other.activeMarketSymbols) &&
        listEquals(selectedMarketSymbols, other.selectedMarketSymbols) &&
        tick == other.tick &&
        message == other.message;
  }

  /// The hashCode method.
  @override
  int get hashCode =>
      status.hashCode ^
      activeMarketSymbols.hashCode ^
      selectedMarketSymbols.hashCode ^
      tick.hashCode ^
      message.hashCode;

  /// The toString method.
  @override
  String toString() {
    return '''
PriceTrackerState{status: $status, activeSymbols: $activeMarketSymbols, 
    selectedSymbols: $selectedMarketSymbols, tick: $tick, message: $message}
    ''';
  }
}

/// Cubit Status that represents the state of active symbols and their prices.
enum PriceTrackerStatus {
  /// Represents the failure status.
  failure,

  /// Represents the success status.
  success,

  /// Represents the loading status.
  pending
}
