import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// A Result type that represents values with two possibilities: either
/// [Result.success] or [Result.failure]. Similar to & inspired by the [Result]
/// type in Rust, Kotlin & Haskell. By convention, the Left side is used to
/// hold an error value and the Right side is used to hold a correct value.
@freezed
class Result<F, S> with _$Result<F, S> {
  /// Creates a new instance of [Result] with the given success value.
  /// Or, the left value.
  const factory Result.success(S val) = _Success;

  /// Creates a new instance of [Result] with the given failure value.
  /// Or, the right value.
  const factory Result.failure(F val) = _Failure;
}
