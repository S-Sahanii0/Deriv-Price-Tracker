import 'package:flutter_test/flutter_test.dart';
import 'package:price_tracker_repository/src/core/core.dart';

void main() {
  group('PriceTrackerFailure', () {
    test('instantiates', () {
      expect(
        PriceTrackerFailure('failure-msg'),
        PriceTrackerFailure('failure-msg'),
      );
    });

    test('toString', () {
      expect(
        PriceTrackerFailure('failure-msg').toString(),
        'PriceTrackerFailure(message: failure-msg)',
      );
    });

    test('equals', () {
      final failure1 = PriceTrackerFailure('failure-msg');
      final failure2 = PriceTrackerFailure('failure-msg');
      expect(failure1, failure2);
      expect(failure1.hashCode, failure2.hashCode);
    });
  });
}
