import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

part 'price_tracker_state.dart';

/// {@template price_tracker_cubit}
/// Bloc which manages the current [PriceTrackerState]. Externally, should only
/// depend on a [PriceTrackerRepository] and nothing else.
/// {@endtemplate}
class PriceTrackerCubit extends Cubit<PriceTrackerState> {
  /// {@macro price_tracker_cubit}
  PriceTrackerCubit({
    required PriceTrackerRepository priceTrackerRepository,
  })  : _priceTrackerRepository = priceTrackerRepository,
        super(
          PriceTrackerState.pending(activeSymbols: const []),
        );

  final PriceTrackerRepository _priceTrackerRepository;

  /// Interacts with the [PriceTrackerRepository] to fetch the active symbols
  /// and updates the state with it.
  void getActiveMarkets() {
    emit(
      PriceTrackerState.pending(
        message: 'Fetching markets',
        activeSymbols: const [],
      ),
    );
    _priceTrackerRepository.getActiveMarkets().when(
          success: _handleActiveMarketsSuccess,
          failure: _handleActiveMarketsFailure,
        );
  }

  void _handleActiveMarketsSuccess(
    Stream<List<ActiveMarketSymbol>> activeSymbols,
  ) =>
      activeSymbols.listen((element) {
        emit(
          PriceTrackerState.success(
            activeSymbols: element,
            message: 'success',
          ),
        );
      });

  void _handleActiveMarketsFailure(PriceTrackerFailure error) => emit(
        PriceTrackerState.failure(
          message: error.message ?? 'Something went wrong',
          activeSymbols: const [],
        ),
      );

  /// Interacts with the [PriceTrackerRepository] to receive
  /// error message if encountered any.
  void receiveError() => _priceTrackerRepository.getErrorStream().listen(
        (error) {
          emit(
            PriceTrackerState.failure(
              message: error,
              activeSymbols: state.activeMarketSymbols,
              selectedSymbols: state.selectedMarketSymbols,
            ),
          );
        },
        onError: (_) => emit(
          PriceTrackerState.failure(
            message: 'Something went wrong',
            activeSymbols: state.activeMarketSymbols,
            selectedSymbols: state.selectedMarketSymbols,
          ),
        ),
      );

  /// A method that emits updated state when user selects a market.
  void selectMarket({required String market}) {
    if (state.tick != null) {
      _priceTrackerRepository.cancelTicks(tickId: state.tick!.id);
    }
    emit(
      PriceTrackerState.success(
        selectedSymbols: state.activeMarketSymbols.where((element) {
          return element.marketDisplayName == market;
        }).toList(),
        activeSymbols: state.activeMarketSymbols,
      ),
    );
  }

  /// A method that emits updated state when user selects a symbol.
  /// It interacts with the [PriceTrackerRepository] to fetch the prices.
  void requestForTick({required String symbol}) {
    if (state.tick?.symbol != symbol) {
      if (state.tick != null) {
        _priceTrackerRepository.cancelTicks(tickId: state.tick!.id);
      }
      emit(
        PriceTrackerState.pending(
          message: 'Fetching tick',
          activeSymbols: state.activeMarketSymbols,
          selectedSymbols: state.selectedMarketSymbols,
        ),
      );
      _priceTrackerRepository.requestForTicks(selectedSymbol: symbol).when(
            success: (_) => _handleRequestTicksSuccess(),
            failure: _handleRequestTicksFailure,
          );
    }
  }

  void _handleRequestTicksSuccess() => _priceTrackerRepository.getTicks().when(
        success: (tick) => tick!.listen(
          (element) {
            emit(
              PriceTrackerState.success(
                tick: element,
                activeSymbols: state.activeMarketSymbols,
                selectedSymbols: state.selectedMarketSymbols,
                message: 'success',
              ),
            );
          },
          onError: (_) => emit(
            PriceTrackerState.failure(
              message: 'Something went wrong',
              activeSymbols: state.activeMarketSymbols,
              selectedSymbols: state.selectedMarketSymbols,
            ),
          ),
        ),
        failure: (error) => emit(
          PriceTrackerState.failure(
            message: error.message ?? 'Something went wrong',
            activeSymbols: state.activeMarketSymbols,
            selectedSymbols: state.selectedMarketSymbols,
          ),
        ),
      );

  void _handleRequestTicksFailure(PriceTrackerFailure error) => emit(
        PriceTrackerState.failure(
          message: error.message ?? 'Something went wrong',
          activeSymbols: state.activeMarketSymbols,
          selectedSymbols: state.selectedMarketSymbols,
        ),
      );

  @override
  Future<void> close() async {
    _priceTrackerRepository.closeStream();
    return super.close();
  }
}
