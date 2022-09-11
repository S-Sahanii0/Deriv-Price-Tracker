// ignore_for_file: prefer_const_constructors
import 'package:price_tracker_api_client/src/models/tick.dart';
import 'package:test/test.dart';

void main() {
  group('Tick', () {
    test('supports value comparisons', () {
      expect(
        Tick(
          ask: 0,
          bid: 0,
          epoch: 123,
          id: 'test',
          pipSize: 0,
          quote: 0,
          symbol: 'test_symbol',
        ),
        Tick(
          ask: 0,
          bid: 0,
          epoch: 123,
          id: 'test',
          pipSize: 0,
          quote: 0,
          symbol: 'test_symbol',
        ),
      );
    });
  });
}
