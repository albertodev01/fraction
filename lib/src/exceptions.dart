import 'package:fraction/fraction.dart';

/// Exception thrown by [Fraction]
class FractionException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Fraction] class
  const FractionException(this.message);

  @override
  String toString() => "FractionException: $message";
}

/// Exception object thrown by [MixedFractionException]
class MixedFractionException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [MixedFraction] class
  const MixedFractionException(this.message);

  @override
  String toString() => "MixedFractionException: $message";
}
