// ignore_for_file: prefer_const_constructors
import 'package:price_tracker_api_client/src/models/active_symbol.dart';
import 'package:test/test.dart';

void main() {
  group('Active Symbol', () {
    test('supports value comparisons', () {
      expect(
        ActiveMarketSymbol(
          allowForwardStarting: 1,
          displayName: 'Test',
          exchangeIsOpen: 0,
          isTradingSuspended: 1,
          market: 'test_market',
          marketDisplayName: 'Test Market',
          pip: 0.01,
          submarket: 'test_submarket',
          submarketDisplayName: 'Test SubMarket',
          symbol: 'test_any',
          symbolType: 'testType',
        ),
        ActiveMarketSymbol(
          allowForwardStarting: 1,
          displayName: 'Test',
          exchangeIsOpen: 0,
          isTradingSuspended: 1,
          market: 'test_market',
          marketDisplayName: 'Test Market',
          pip: 0.01,
          submarket: 'test_submarket',
          submarketDisplayName: 'Test SubMarket',
          symbol: 'test_any',
          symbolType: 'testType',
        ),
      );
    });
  });
}
