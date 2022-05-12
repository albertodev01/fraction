import 'package:fraction/fraction.dart';

/// Extension method that adds [Fraction] functionalities to [num].
extension FractionNum on num {
  /// Builds a [Fraction] from an [int] or a [double].
  Fraction toFraction() {
    if (this is int) {
      return Fraction(toInt());
    }

    return Fraction.fromDouble(toDouble());
  }
}
