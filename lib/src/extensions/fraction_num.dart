import 'package:fraction/fraction.dart';

/// Extension method that adds [Fraction] functionalities to [num].
extension FractionNum on num {
  /// Builds a [Fraction] from this number.
  ///
  /// An [int] is converted exactly. A [double] is approximated with
  /// [Fraction.fromDouble] using its default precision:
  ///
  /// ```dart
  ///  5.toFraction(); // 5
  ///  1.5.toFraction(); // 3/2
  /// ```
  ///
  /// Throws a [FractionException] if this number is NaN or infinite, or if it
  /// is too large (or too close to zero) to be represented with [int] values.
  Fraction toFraction() {
    if (this is int) {
      return Fraction(toInt());
    }
    return Fraction.fromDouble(toDouble());
  }
}
