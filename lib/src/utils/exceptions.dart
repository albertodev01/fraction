import 'package:fraction/fraction.dart';

/// Exception thrown by [Fraction]
class FractionException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Fraction] class
  const FractionException(this.message);

  @override
  String toString() => "FractionException: $message";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is FractionException) {
      final exception = other;

      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 31 * result + message.hashCode;
    return result;
  }
}

/// Exception object thrown by [MixedFractionException]
class MixedFractionException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [MixedFraction] class
  const MixedFractionException(this.message);

  @override
  String toString() => "MixedFractionException: $message";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is MixedFractionException) {
      final exception = other;

      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 31 * result + message.hashCode;
    return result;
  }
}
