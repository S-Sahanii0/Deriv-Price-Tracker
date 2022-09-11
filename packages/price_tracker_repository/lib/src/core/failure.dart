import 'package:flutter/material.dart';

/// Represents a failure in the repository layer.
abstract class Failure implements Exception {}

/// {@template price_tracker_failure}
/// Returned when an exception is caught in the PriceTrackerRepository.
/// {@endtemplate}
@immutable
class PriceTrackerFailure extends Failure {
  /// {@macro price_tracker_failure}
  PriceTrackerFailure([this.message]);

  /// The message associated with the failure.
  final String? message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriceTrackerFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'PriceTrackerFailure(message: $message)';
}
