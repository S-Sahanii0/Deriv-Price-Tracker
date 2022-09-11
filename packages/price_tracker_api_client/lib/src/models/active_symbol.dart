import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_symbol.freezed.dart';
part 'active_symbol.g.dart';

/// {@template active_market_symbols}
/// A model that represents data about a markets available at Deriv.
/// {@endtemplate}
@freezed
class ActiveMarketSymbol with _$ActiveMarketSymbol {
  /// {@macro active_market_symbols}
  const factory ActiveMarketSymbol({
    required final int allowForwardStarting,
    required final String displayName,
    required final int exchangeIsOpen,
    required final int isTradingSuspended,
    required final String market,
    required final String marketDisplayName,
    required final num pip,
    required final String submarket,
    required final String submarketDisplayName,
    required final String symbol,
    required final String symbolType,
  }) = _ActiveMarketSymbol;

  /// Converts a JSON [Map] into a [ActiveMarketSymbol] instance
  factory ActiveMarketSymbol.fromJson(Map<String, dynamic> json) =>
      _$ActiveMarketSymbolFromJson(json);
}
