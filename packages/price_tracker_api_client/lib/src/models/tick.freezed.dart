// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tick _$TickFromJson(Map<String, dynamic> json) {
  return _Tick.fromJson(json);
}

/// @nodoc
mixin _$Tick {
  double get ask => throw _privateConstructorUsedError;
  double get bid => throw _privateConstructorUsedError;
  int get epoch => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int get pipSize => throw _privateConstructorUsedError;
  double get quote => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TickCopyWith<Tick> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TickCopyWith<$Res> {
  factory $TickCopyWith(Tick value, $Res Function(Tick) then) =
      _$TickCopyWithImpl<$Res>;
  $Res call(
      {double ask,
      double bid,
      int epoch,
      String id,
      int pipSize,
      double quote,
      String symbol});
}

/// @nodoc
class _$TickCopyWithImpl<$Res> implements $TickCopyWith<$Res> {
  _$TickCopyWithImpl(this._value, this._then);

  final Tick _value;
  // ignore: unused_field
  final $Res Function(Tick) _then;

  @override
  $Res call({
    Object? ask = freezed,
    Object? bid = freezed,
    Object? epoch = freezed,
    Object? id = freezed,
    Object? pipSize = freezed,
    Object? quote = freezed,
    Object? symbol = freezed,
  }) {
    return _then(_value.copyWith(
      ask: ask == freezed
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      bid: bid == freezed
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      epoch: epoch == freezed
          ? _value.epoch
          : epoch // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pipSize: pipSize == freezed
          ? _value.pipSize
          : pipSize // ignore: cast_nullable_to_non_nullable
              as int,
      quote: quote == freezed
          ? _value.quote
          : quote // ignore: cast_nullable_to_non_nullable
              as double,
      symbol: symbol == freezed
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TickCopyWith<$Res> implements $TickCopyWith<$Res> {
  factory _$$_TickCopyWith(_$_Tick value, $Res Function(_$_Tick) then) =
      __$$_TickCopyWithImpl<$Res>;
  @override
  $Res call(
      {double ask,
      double bid,
      int epoch,
      String id,
      int pipSize,
      double quote,
      String symbol});
}

/// @nodoc
class __$$_TickCopyWithImpl<$Res> extends _$TickCopyWithImpl<$Res>
    implements _$$_TickCopyWith<$Res> {
  __$$_TickCopyWithImpl(_$_Tick _value, $Res Function(_$_Tick) _then)
      : super(_value, (v) => _then(v as _$_Tick));

  @override
  _$_Tick get _value => super._value as _$_Tick;

  @override
  $Res call({
    Object? ask = freezed,
    Object? bid = freezed,
    Object? epoch = freezed,
    Object? id = freezed,
    Object? pipSize = freezed,
    Object? quote = freezed,
    Object? symbol = freezed,
  }) {
    return _then(_$_Tick(
      ask: ask == freezed
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      bid: bid == freezed
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      epoch: epoch == freezed
          ? _value.epoch
          : epoch // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pipSize: pipSize == freezed
          ? _value.pipSize
          : pipSize // ignore: cast_nullable_to_non_nullable
              as int,
      quote: quote == freezed
          ? _value.quote
          : quote // ignore: cast_nullable_to_non_nullable
              as double,
      symbol: symbol == freezed
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Tick implements _Tick {
  _$_Tick(
      {required this.ask,
      required this.bid,
      required this.epoch,
      required this.id,
      required this.pipSize,
      required this.quote,
      required this.symbol});

  factory _$_Tick.fromJson(Map<String, dynamic> json) => _$$_TickFromJson(json);

  @override
  final double ask;
  @override
  final double bid;
  @override
  final int epoch;
  @override
  final String id;
  @override
  final int pipSize;
  @override
  final double quote;
  @override
  final String symbol;

  @override
  String toString() {
    return 'Tick(ask: $ask, bid: $bid, epoch: $epoch, id: $id, pipSize: $pipSize, quote: $quote, symbol: $symbol)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Tick &&
            const DeepCollectionEquality().equals(other.ask, ask) &&
            const DeepCollectionEquality().equals(other.bid, bid) &&
            const DeepCollectionEquality().equals(other.epoch, epoch) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.pipSize, pipSize) &&
            const DeepCollectionEquality().equals(other.quote, quote) &&
            const DeepCollectionEquality().equals(other.symbol, symbol));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(ask),
      const DeepCollectionEquality().hash(bid),
      const DeepCollectionEquality().hash(epoch),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(pipSize),
      const DeepCollectionEquality().hash(quote),
      const DeepCollectionEquality().hash(symbol));

  @JsonKey(ignore: true)
  @override
  _$$_TickCopyWith<_$_Tick> get copyWith =>
      __$$_TickCopyWithImpl<_$_Tick>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TickToJson(
      this,
    );
  }
}

abstract class _Tick implements Tick {
  factory _Tick(
      {required final double ask,
      required final double bid,
      required final int epoch,
      required final String id,
      required final int pipSize,
      required final double quote,
      required final String symbol}) = _$_Tick;

  factory _Tick.fromJson(Map<String, dynamic> json) = _$_Tick.fromJson;

  @override
  double get ask;
  @override
  double get bid;
  @override
  int get epoch;
  @override
  String get id;
  @override
  int get pipSize;
  @override
  double get quote;
  @override
  String get symbol;
  @override
  @JsonKey(ignore: true)
  _$$_TickCopyWith<_$_Tick> get copyWith => throw _privateConstructorUsedError;
}
