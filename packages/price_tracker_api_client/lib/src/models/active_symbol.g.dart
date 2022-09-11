// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_symbol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActiveMarketSymbol _$$_ActiveMarketSymbolFromJson(
        Map<String, dynamic> json) =>
    _$_ActiveMarketSymbol(
      allowForwardStarting: json['allow_forward_starting'] as int,
      displayName: json['display_name'] as String,
      exchangeIsOpen: json['exchange_is_open'] as int,
      isTradingSuspended: json['is_trading_suspended'] as int,
      market: json['market'] as String,
      marketDisplayName: json['market_display_name'] as String,
      pip: json['pip'] as num,
      submarket: json['submarket'] as String,
      submarketDisplayName: json['submarket_display_name'] as String,
      symbol: json['symbol'] as String,
      symbolType: json['symbol_type'] as String,
    );

Map<String, dynamic> _$$_ActiveMarketSymbolToJson(
        _$_ActiveMarketSymbol instance) =>
    <String, dynamic>{
      'allow_forward_starting': instance.allowForwardStarting,
      'display_name': instance.displayName,
      'exchange_is_open': instance.exchangeIsOpen,
      'is_trading_suspended': instance.isTradingSuspended,
      'market': instance.market,
      'market_display_name': instance.marketDisplayName,
      'pip': instance.pip,
      'submarket': instance.submarket,
      'submarket_display_name': instance.submarketDisplayName,
      'symbol': instance.symbol,
      'symbol_type': instance.symbolType,
    };
