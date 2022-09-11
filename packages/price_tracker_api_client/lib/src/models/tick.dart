import 'package:freezed_annotation/freezed_annotation.dart';

part 'tick.freezed.dart';
part 'tick.g.dart';

/// {@template tick}
/// A model that represents data about price of a particular symbol.
/// {@endtemplate}
@freezed
class Tick with _$Tick {
  /// {@macro tick}
  factory Tick({
    required final double ask,
    required final double bid,
    required final int epoch,
    required final String id,
    required final int pipSize,
    required final double quote,
    required final String symbol,
  }) = _Tick;

  /// Converts a JSON [Map] into a [Tick] instance
  factory Tick.fromJson(Map<String, dynamic> json) => _$TickFromJson(json);
}
