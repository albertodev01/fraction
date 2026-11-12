import 'package:fraction/fraction.dart';

/// {@template fraction_exception}
/// Exception object thrown by a [Fraction] object.
/// {@endtemplate}
class FractionException implements Exception {
  /// {@macro fraction_exception}
  const new(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'FractionException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is FractionException) {
      final exception = other;
      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => message.hashCode;
}

/// {@template mixed_fraction_exception}
/// Exception object thrown by a [MixedFraction] object.
/// {@endtemplate}
class MixedFractionException implements Exception {
  /// {@macro mixed_fraction_exception}
  const new(this.message);

  /// Error message.
  final String message;

  @override
  String toString() => 'MixedFractionException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is MixedFractionException) {
      final exception = other;

      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => message.hashCode;
}
