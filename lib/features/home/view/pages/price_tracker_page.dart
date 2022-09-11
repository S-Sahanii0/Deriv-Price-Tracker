import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/features/home/cubit/price_tracker_cubit.dart';
import 'package:price_tracker/features/home/view/widgets/widgets.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

/// {@template price_tracker_page}
/// The root page of the Price Tracker App. Depends on an instance of
/// [PriceTrackerCubit] for interacting with the external layers.
/// {@endtemplate}
class PriceTrackerPage extends StatelessWidget {
  /// {@macro price_tracker_page}
  const PriceTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PriceTrackerCubit(
        priceTrackerRepository: context.read<PriceTrackerRepository>(),
      )
        ..getActiveMarkets()
        ..receiveError(),
      child: const PriceTrackerView(),
    );
  }
}

/// {@template price_tracker_view}
/// Responds to [PriceTrackerState] changes and notifies
/// user actions to the [PriceTrackerCubit].
/// {@endtemplate}
class PriceTrackerView extends StatefulWidget {
  /// {@macro price_tracker_view}
  const PriceTrackerView({super.key});

  @override
  State<PriceTrackerView> createState() => _PriceTrackerViewState();
}

class _PriceTrackerViewState extends State<PriceTrackerView> {
  /// Value notifier for markets dropdown.
  final _selectedMarket = ValueNotifier<String?>(null);

  /// Value notifier for symbols dropdown.
  final _selectedSymbol = ValueNotifier<String?>(null);

  /// This method is used to avoid getting duplicate market names.
  List<String> _getFilteredMarkets(List<ActiveMarketSymbol> markets) {
    final marketList = <String>[];
    for (var i = 0; i < markets.length; i++) {
      if (marketList
          .where((element) => element == markets[i].marketDisplayName)
          .isEmpty) {
        marketList.add(markets[i].marketDisplayName);
      }
    }
    return marketList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Tracker'),
      ),
      body: BlocConsumer<PriceTrackerCubit, PriceTrackerState>(
        listener: (context, state) {
          if (state.status == PriceTrackerStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.white,
                content: PriceTrackerSnackBar(
                  message: state.message!,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          // todo: change to initial??
          if (state.status == PriceTrackerStatus.pending &&
              state.message == 'Fetching markets') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedMarket,
                    builder: (context, value, child) {
                      return CustomDropDownButton(
                        hint: 'Select a Market',
                        value: value,
                        items: _getFilteredMarkets(state.activeMarketSymbols)
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(key: ValueKey(e), e),
                              ),
                            )
                            .toList(),
                        onChanged: (e) {
                          _selectedMarket.value = e;
                          _selectedSymbol.value = null;
                          context
                              .read<PriceTrackerCubit>()
                              .selectMarket(market: e!);
                        },
                      );
                    },
                  ),
                  if (state.selectedMarketSymbols != null)
                    ValueListenableBuilder<String?>(
                      valueListenable: _selectedSymbol,
                      builder: (context, val, child) {
                        return CustomDropDownButton(
                          hint: 'Select a symbol',
                          value: val,
                          items: state.selectedMarketSymbols == null ||
                                  state.selectedMarketSymbols!.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                    value: 'No symbols found',
                                    child: Text('No symbols found'),
                                  )
                                ]
                              : state.selectedMarketSymbols!
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e.displayName,
                                      child: Text(e.displayName),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (e) {
                            _selectedSymbol.value = e;
                            context.read<PriceTrackerCubit>().requestForTick(
                                  symbol: state.selectedMarketSymbols!
                                      .where(
                                        (element) => element.displayName == e,
                                      )
                                      .first
                                      .symbol,
                                );
                          },
                        );
                      },
                    ),
                  if (state.tick != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        state.tick!.bid.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (state.message == 'Fetching tick')
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
